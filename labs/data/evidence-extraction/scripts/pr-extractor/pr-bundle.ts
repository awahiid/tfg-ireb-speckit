import { Octokit } from "@octokit/rest";
import fs from "fs";

const octokit = new Octokit({
    auth: process.env.GITHUB_TOKEN,
});

type Dataset = {
    entries: {
        id: string;
        pr_number: number;
    }[];
};

const owner = "goauthentik";
const repo = "authentik";

async function getPRBundle(pr_number: number) {
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

async function run(dataset: Dataset) {
    const out: Record<string, any> = {};

    for (const entry of dataset.entries) {
        try {
            out[entry.id] = await getPRBundle(entry.pr_number);
            await new Promise(r => setTimeout(r, 300));
        } catch (e: any) {
            out[entry.id] = { error: e.message };
        }
    }

    fs.writeFileSync("pr_dump.json", JSON.stringify(out, null, 2));
}

// load dataset
const dataset = JSON.parse(fs.readFileSync("dataset.json", "utf-8"));

run(dataset);