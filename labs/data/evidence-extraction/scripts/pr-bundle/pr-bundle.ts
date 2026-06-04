import { Octokit } from "@octokit/rest";
import fs from "fs";
import path from "path";
import "dotenv/config";

if (!process.env.GITHUB_TOKEN) {
    throw new Error("Missing GITHUB_TOKEN");
}

const octokit = new Octokit({
    auth: process.env.GITHUB_TOKEN,
});

type Dataset = {
    meta: {
        repo: string;
    };
    entries: {
        id: string;
        pr_number: number;
    }[];
};

const DATASETS_DIR = path.resolve(
    "../../evidence"
);

const OUTPUT_BASE = path.resolve(
    "../../evidence"
);

function ensureDir(dir: string) {
    if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
    }
}

async function getPRBundle(owner: string, repo: string, pr_number: number) {
    const { data: pr } = await octokit.pulls.get({
        owner,
        repo,
        pull_number: pr_number,
    });

    const issueComments = await octokit.issues.listComments({
        owner,
        repo,
        issue_number: pr_number,
    });

    const reviewComments = await octokit.pulls.listReviewComments({
        owner,
        repo,
        pull_number: pr_number,
    });

    const reviews = await octokit.pulls.listReviews({
        owner,
        repo,
        pull_number: pr_number,
    });

    const commits = await octokit.pulls.listCommits({
        owner,
        repo,
        pull_number: pr_number,
    });

    const files = await octokit.pulls.listFiles({
        owner,
        repo,
        pull_number: pr_number,
    });

    return {
        pr: {
            number: pr.number,
            title: pr.title,
            body: pr.body,
            state: pr.state,
            merged: pr.merged,
            user: pr.user?.login,
            created_at: pr.created_at,
            updated_at: pr.updated_at,
            base: pr.base.ref,
            head: pr.head.ref,
            merge_commit_sha: pr.merge_commit_sha,
        },

        issue_comments: issueComments.data.map(c => ({
            user: c.user?.login,
            body: c.body,
            created_at: c.created_at,
        })),

        review_comments: reviewComments.data.map(c => ({
            user: c.user?.login,
            body: c.body,
            path: c.path,
            diff_hunk: c.diff_hunk,
            line: c.line,
            created_at: c.created_at,
        })),

        reviews: reviews.data.map(r => ({
            user: r.user?.login,
            state: r.state,
            body: r.body,
            submitted_at: r.submitted_at,
        })),

        commits: commits.data.map(c => ({
            sha: c.sha,
            message: c.commit.message,
            author: c.commit.author?.name,
            date: c.commit.author?.date,
        })),

        files: files.data.map(f => ({
            filename: f.filename,
            status: f.status,
            additions: f.additions,
            deletions: f.deletions,
            changes: f.changes,
            patch: f.patch,
        })),
    };
}

async function savePR(repo: string, entryId: string, data: any) {
    const repoDir = path.join(OUTPUT_BASE, repo);
    ensureDir(repoDir);

    const filePath = path.join(repoDir, `${entryId}.json`);
    fs.writeFileSync(filePath, JSON.stringify(data, null, 2), "utf-8");
}

function loadDatasets(dir: string): string[] {
    return fs
        .readdirSync(dir)
        .filter(f => f.endsWith(".json"))
        .map(f => path.join(dir, f));
}

async function runDataset(filePath: string) {
    const dataset: Dataset = JSON.parse(
        fs.readFileSync(filePath, "utf-8")
    );

    const repoFull = dataset.meta.repo; // goauthentik/authentik
    const [owner, repo] = repoFull.split("/");

    for (const entry of dataset.entries) {
        try {
            const bundle = await getPRBundle(owner, repo, entry.pr_number);

            await savePR(repo, entry.id, bundle);

            await new Promise(r => setTimeout(r, 300));
        } catch (e: any) {
            await savePR(repo, entry.id, {
                error: e.message,
                pr_number: entry.pr_number,
            });
        }
    }
}

async function run() {
    const datasets = loadDatasets(DATASETS_DIR);

    for (const file of datasets) {
        await runDataset(file);
    }
}

run();