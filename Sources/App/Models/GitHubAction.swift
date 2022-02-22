//
//  GitHubAction.swift
//
//
//  Created by lvv.me on 2022/2/19.
//

import Foundation

enum GitHubAction: String, Decodable {
    case assigned
    case auto_merge_disabled
    case auto_merge_enabled
    /// If the action is closed and the merged key is false, the pull request was closed with unmerged commits. If the action is closed and the merged key is true, the pull request was merged.
    case closed
    case converted_to_draft
    case edited
    case labeled
    case locked
    case opened
    case ready_for_review
    case reopened
    case review_request_removed
    case review_requested
    /// Triggered when a pull request's head branch is updated. For example, when the head branch is updated from the base branch, when new commits are pushed to the head branch, or when the base branch is changed.
    case synchronize
    case unassigned
    case unlabeled
    case unlocked

    /// A pull request review is submitted into a non-pending state.
    case submitted
    /// A review has been dismissed.
    case dismissed

    case created
    case deleted

    /// A new job was created.
    case queued
    /// The job has started processing on the runner.
    case in_progress
    /// The `status` of the job is `completed`.
    case completed

    case requested
}
