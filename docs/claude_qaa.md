Full Practice Exam 1 : Claude Certified Development

Question 1Correct
An application compares two contracts and must preserve which document supports each finding. The selected approach must produce clear request, response, and operational behavior across the workflow. Which TWO message-design choices best maintain source identity?
Your selection is correct
Send each contract in a separate document block with a stable title that identifies its source. Reviewers would evaluate whether this can preserve source identity for every finding.
Convert every page into one unlabeled image stream, interleave unrelated instructions, and omit any mapping between pages and contract sources. The design would use this reasoning to preserve source identity for every finding.
Upload only the first contract and ask Claude to infer differences from knowledge. This would become the basis used to preserve source identity for every finding.
Paste both contracts into one text string without preserving document names, boundaries, or source identity. The design would use this reasoning to preserve source identity for every finding.
Your selection is correct
Place the comparison question after document blocks and request source-specific citations in the answer. The selected method would be used to preserve source identity for every finding.
Overall explanation
Correct options:

Send each contract in a separate document block with a stable title that identifies its source. Reviewers would evaluate whether this can preserve source identity for every finding.

Separate document blocks preserve the two source boundaries in the request. Stable titles give Claude and the application an identifier for each contract. The option therefore enables the implementation to preserve source identity for every finding.

The block structure remains useful when the contracts contain similar clause numbering or repeated language. Findings can refer to the intended title instead of an ambiguous combined text. The resulting control can be exercised repeatedly during regression testing.

Request tests should swap document order while keeping titles fixed. Correct attribution after the swap demonstrates that source identity does not depend on position alone. Future changes can be reviewed without losing the original reasoning.

Place the comparison question after document blocks and request source-specific citations in the answer. The selected method would be used to preserve source identity for every finding.

Putting the question after the documents lets the request establish source content before asking for analysis. Source-specific citations make the attribution requirement explicit in the desired answer. The important point is that the design can preserve source identity for every finding.

Claude citation support can tie cited passages to document content and metadata. The application can then render findings with the contract title that supports each statement. The implementation can record the result and compare it with the acceptance criteria.

Validation should include one clause present in only one contract and another that conflicts across both. The expected result must cite the correct titled source for each finding. The same evidence can support monitoring, rollback, and later revisions.

Incorrect options:

Paste both contracts into one text string without preserving document names, boundaries, or source identity. The design would use this reasoning to preserve source identity for every finding.

Flattening both contracts removes the boundary needed to associate a clause with its source. Even accurate text extraction cannot restore a document name that was never supplied. The proposed assumption does not help the implementation preserve source identity for every finding.

The final answer could blend provisions while appearing coherent. That outcome fails the requirement to trace each finding to the supporting contract. The gap would remain visible during testing or production operation.

Upload only the first contract and ask Claude to infer differences from knowledge. This would become the basis used to preserve source identity for every finding.

A comparison requires evidence from both contracts, but this option supplies only one. General knowledge cannot reconstruct the missing document or its exact provisions. That approach conflicts with the need to preserve source identity for every finding.

Any claimed difference would be unsupported by the absent source. The design therefore cannot provide reliable two-document attribution. The implementation would still fail the relevant acceptance or safety check.

Convert every page into one unlabeled image stream, interleave unrelated instructions, and omit any mapping between pages and contract sources. The design would use this reasoning to preserve source identity for every finding.

An unlabeled interleaved image stream destroys the mapping between pages and contracts. Unrelated instructions further obscure where evidence ends and task direction begins. Reviewers could not use this as evidence that the system will preserve source identity for every finding.

Visual input can preserve page appearance, but it does not create missing source metadata. The application still needs explicit document boundaries and identifiers. A separate control would still be required before the option could satisfy the requirement.

References:

https://platform.claude.com/docs/en/build-with-claude/pdf-support

https://platform.claude.com/docs/en/build-with-claude/citations

https://platform.claude.com/docs/en/build-with-claude/vision
Domain
Applications and Integration
Question 2Correct
Claude follows an incident-summary instruction inconsistently despite clear field names. Any revision must be evaluated against the same quality and latency criteria before release. Which prompt change most directly demonstrates the required pattern?
Repeat the same instruction in uppercase at the beginning and end of the prompt. The design would use this reasoning to produce a consistent incident-summary pattern.
Remove the field constraints and let each response choose a format that fits its content. The implementation would treat this as the rule for how to produce a consistent incident-summary pattern.
Add unrelated background documents so Claude has more tokens available for deciding the format. This would become the basis used to produce a consistent incident-summary pattern.
Your answer is correct
Provide representative input-output examples that show the exact fields and acceptable values. This would become the basis used to produce a consistent incident-summary pattern.
Overall explanation
Correct option:

Provide representative input-output examples that show the exact fields and acceptable values. This would become the basis used to produce a consistent incident-summary pattern.

Representative examples show Claude how inputs map to the expected fields and values. This is few-shot prompting, which is useful when instructions alone do not establish consistent behavior. In this scenario, that is what allows the team to produce a consistent incident-summary pattern.

Examples should cover realistic cases and remain aligned with the written instruction. Contradictory or unrepresentative demonstrations can teach the wrong pattern. This makes the expected behavior easier to measure under production-like conditions.

The team should test the revised prompt on held-out incidents. That evaluation reveals whether the examples improve consistency beyond the examples themselves. That makes the design easier to audit and maintain over time.

Incorrect options:

Repeat the same instruction in uppercase at the beginning and end of the prompt. The design would use this reasoning to produce a consistent incident-summary pattern.

Capitalization does not add information about the desired mapping from incident text to fields. Repetition can make a prompt longer without resolving the ambiguity. The design would still fail to produce a consistent incident-summary pattern.

A useful revision should demonstrate successful behavior or sharpen the missing constraint. Emphasis alone is not that demonstration. The missing control would have to be added elsewhere in the design.

Add unrelated background documents so Claude has more tokens available for deciding the format. This would become the basis used to produce a consistent incident-summary pattern.

Unrelated documents add context bloat and may distract from the formatting task. Token volume is not equivalent to relevant guidance. Reviewers could not use this as evidence that the system will produce a consistent incident-summary pattern.

Examples should be selected because they illustrate the required transformation. Extra background should appear only when it affects the answer. A separate control would still be required before the option could satisfy the requirement.

Remove the field constraints and let each response choose a format that fits its content. The implementation would treat this as the rule for how to produce a consistent incident-summary pattern.

Removing constraints increases output variability when the application needs a stable structure. It also makes downstream validation more difficult. This would not reliably produce a consistent incident-summary pattern.

Flexible prose can be valuable for other tasks, but it conflicts with the stated formatting requirement. The prompt should clarify rather than relax the contract. The team could not use this choice as reliable evidence for release.

References:

https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices

https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview

https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/increase-consistency
Domain
Prompt and Context Engineering
Question 3Correct
A developer discovers that a production Claude API key was committed to a public repository, and account usage now looks suspicious. Security decisions must rely on enforced permissions and validation rather than prompt text alone. What should the team do first?
Wait for evidence of misuse before changing the key, because rotation could interrupt traffic. The design would use this reasoning to revoke the exposed key and rotate securely.
Your answer is correct
Revoke the key immediately, create a replacement, and store the new key in secret management. The team would then revoke the exposed key and rotate securely based on that assumption.
Delete the repository commit and keep using the existing key because removing its history prevents future unauthorized API requests. The selected method would be used to revoke the exposed key and rotate securely.
Move the exposed key into an ignored dotenv file, then continue using it after reviewing account usage. Reviewers would evaluate whether this can revoke the exposed key and rotate securely.
Overall explanation
Correct option:

Revoke the key immediately, create a replacement, and store the new key in secret management. The team would then revoke the exposed key and rotate securely based on that assumption.

A public key must be treated as compromised because anyone who copied it may continue using it. Immediate revocation invalidates the exposed credential and stops future requests made with that key. The important point is that the design can revoke the exposed key and rotate securely.

The replacement should be stored through a secrets-management mechanism and injected at runtime. This reduces the chance that the new credential will enter source history again. The implementation can record the result and compare it with the acceptance criteria.

The team should also review usage and logs, but that investigation should not delay revocation. Containment comes first when a live production credential has been exposed. The same evidence can support monitoring, rollback, and later revisions.

Incorrect options:

Delete the repository commit and keep using the existing key because removing its history prevents future unauthorized API requests. The selected method would be used to revoke the exposed key and rotate securely.

Removing a visible commit does not invalidate a credential that another party already copied. Repository mirrors, forks, caches, and local clones may preserve the secret. Reviewers could not use this as evidence that the system will revoke the exposed key and rotate securely.

Continuing to use the exposed key leaves the account open to further unauthorized requests. Source cleanup is useful only after the credential itself is revoked. A separate control would still be required before the option could satisfy the requirement.

Wait for evidence of misuse before changing the key, because rotation could interrupt traffic. The design would use this reasoning to revoke the exposed key and rotate securely.

Waiting for conclusive misuse extends the period in which an attacker can use the key. The suspicious usage in the scenario makes prompt containment even more urgent. This would not reliably revoke the exposed key and rotate securely.

A planned rotation process should reduce production disruption without preserving a known exposure. Operational convenience is not a sufficient reason to keep the credential active. The team could not use this choice as reliable evidence for release.

Move the exposed key into an ignored dotenv file, then continue using it after reviewing account usage. Reviewers would evaluate whether this can revoke the exposed key and rotate securely.

An ignored dotenv file can help prevent a replacement key from being committed locally. Moving the already exposed value does not make that value secret again. The proposed assumption does not help the implementation revoke the exposed key and rotate securely.

Usage review helps scope an incident, but monitoring alone cannot block a copied key. Revocation is the deterministic control that removes its authority. The gap would remain visible during testing or production operation.

References:

https://support.anthropic.com/en/articles/9767949-api-key-best-practices-keeping-your-keys-safe-and-secure

https://support.anthropic.com/en/articles/8384961-what-should-i-do-if-i-suspect-my-api-key-has-been-compromised

https://docs.anthropic.com/en/docs/claude-code/iam
Domain
Security and Safety
Question 4Correct
A long-running research assistant nears its context limit but must retain the user's goal, constraints, and accepted findings. The design should keep instructions, evidence, and requested output boundaries easy for Claude to distinguish. What should it do next?
Delete the earliest turns without recording their decisions, then continue using only the most recent messages. The application would follow this approach to preserve goals and accepted findings across sessions.
Move all historical tool outputs into the main system prompt so none can ever be removed later. Reviewers would evaluate whether this can preserve goals and accepted findings across sessions before release.
Cache history and assume cached tokens no longer occupy the context window. The implementation would treat this as the rule for how to preserve goals and accepted findings across sessions.
Your answer is correct
Compact earlier history into a summary, preserve key state, and verify continuity afterward. The team would apply the same decision when it must preserve goals and accepted findings across sessions.
Overall explanation
Correct option:

Compact earlier history into a summary, preserve key state, and verify continuity afterward. The team would apply the same decision when it must preserve goals and accepted findings across sessions.

Compaction replaces detailed earlier context with a shorter summary that supports continued work. The summary should preserve the user's objective, constraints, confirmed facts, and unresolved questions. That directly supports the need to preserve goals and accepted findings across sessions.

Critical state can also remain in explicit application memory rather than depending on an implicit conversation trace. This makes recovery and inspection more reliable. It gives reviewers concrete evidence instead of relying on an informal assumption.

After compaction, a continuity check can confirm that the assistant still follows the accepted state. That validation catches omissions before further steps compound them. This also reduces ambiguity when the team investigates a regression.

Incorrect options:

Delete the earliest turns without recording their decisions, then continue using only the most recent messages. The application would follow this approach to preserve goals and accepted findings across sessions.

Blindly deleting early turns can remove constraints, evidence, and accepted decisions. Recency alone does not identify what remains important to the task. The proposed assumption does not help the implementation preserve goals and accepted findings across sessions.

A curated summary should preserve durable state before detailed history is removed. The application then has an artifact it can validate. The gap would remain visible during testing or production operation.

Cache history and assume cached tokens no longer occupy the context window. The implementation would treat this as the rule for how to preserve goals and accepted findings across sessions.

Prompt caching changes processing cost and latency for matching prefixes, not context occupancy. Cached input still contributes to the context window. The option leaves no dependable way to preserve goals and accepted findings across sessions.

Caching the full history therefore does not solve context bloat. The application needs a content-reduction strategy such as compaction or selective clearing. For that reason, the option does not meet the scenario as written.

Move all historical tool outputs into the main system prompt so none can ever be removed later. Reviewers would evaluate whether this can preserve goals and accepted findings across sessions before release.

Moving every tool result into the system prompt preserves bloat rather than reducing it. Old results can be large and irrelevant to later steps. The design would still fail to preserve goals and accepted findings across sessions.

System instructions should contain durable guidance, not an unfiltered execution log. Selective tool-result clearing or compaction is more appropriate. The missing control would have to be added elsewhere in the design.

References:

https://platform.claude.com/docs/en/build-with-claude/compaction

https://platform.claude.com/docs/en/build-with-claude/context-windows

https://platform.claude.com/docs/en/build-with-claude/context-editing
Domain
Prompt and Context Engineering
Question 5Correct
After an organization splits resources across workspaces, a service still completes ordinary Messages API calls with its existing key. Requests for a file created in another workspace now return HTTP 403 permission_error. What is the most likely diagnosis?
The request is malformed, so the API reports invalid_request_error before checking any credential or resource access. The application would follow this approach to diagnose workspace-scoped permission failures correctly.
Your answer is correct
The key authenticated successfully but lacks permission for the requested resource, so access configuration is the primary fault. The team would apply the same decision when it must diagnose workspace-scoped permission failures correctly.
Anthropic is temporarily overloaded, so the client should interpret every 403 response as retryable 529 condition. The selected method would be used to diagnose workspace-scoped permission failures correctly.
The organization exceeded its rate limit, so immediate retries will convert permission_error into a successful response. The selected method would be used to diagnose workspace-scoped permission failures correctly.
Overall explanation
Correct option:

The key authenticated successfully but lacks permission for the requested resource, so access configuration is the primary fault. The team would apply the same decision when it must diagnose workspace-scoped permission failures correctly.

HTTP 403 permission_error indicates that the authenticated key is not allowed to use the requested resource. The continued success of other API calls shows that the key is accepted for at least some operations. This is the mechanism the team needs to diagnose workspace-scoped permission failures correctly.

Workspace API keys are scoped to resources in their own workspace. Moving or creating the file elsewhere can therefore make only that resource inaccessible to the existing key. The team can verify the behavior with explicit checks before release.

The team should inspect workspace ownership and the key's allowed resource scope before changing request logic. A correctly scoped key or resource placement addresses the evidence directly. This keeps the production decision traceable when the system changes.

Incorrect options:

The request is malformed, so the API reports invalid_request_error before checking any credential or resource access. The application would follow this approach to diagnose workspace-scoped permission failures correctly.

Malformed request syntax or invalid parameters normally produce an invalid_request_error with HTTP 400. The observed response is explicitly a 403 permission_error instead. The design would still fail to diagnose workspace-scoped permission failures correctly.

The service also succeeds on ordinary Messages calls with the same key. That evidence makes a generally malformed request an incomplete diagnosis. The missing control would have to be added elsewhere in the design.

The organization exceeded its rate limit, so immediate retries will convert permission_error into a successful response. The selected method would be used to diagnose workspace-scoped permission failures correctly.

Rate limiting is reported as HTTP 429 rate_limit_error rather than HTTP 403 permission_error. Retries do not change whether a key is authorized for a workspace resource. This would not reliably diagnose workspace-scoped permission failures correctly.

A retry policy may be appropriate for throttling, but the client must classify the error correctly first. Here the stable resource-specific boundary points to access configuration. The team could not use this choice as reliable evidence for release.

Anthropic is temporarily overloaded, so the client should interpret every 403 response as retryable 529 condition. The selected method would be used to diagnose workspace-scoped permission failures correctly.

Temporary API overload is reported as HTTP 529 overloaded_error. A 403 response should not be relabeled as 529 simply because retry behavior is available. The proposed assumption does not help the implementation diagnose workspace-scoped permission failures correctly.

The selective failure of one cross-workspace resource also conflicts with a platform-wide overload diagnosis. Authorization scope explains that selectivity. The gap would remain visible during testing or production operation.

References:

https://platform.claude.com/docs/en/api/errors

https://platform.claude.com/docs/en/manage-claude/workspaces

https://platform.claude.com/docs/en/manage-claude/api-and-data-retention
Domain
Eval, Testing, and Debugging
Question 6Correct
A maintenance assistant must interpret open-ended incident evidence and propose actions, but every executed action must satisfy a machine-enforced target allowlist and change window. The design must balance model reasoning with deterministic controls and observable execution. Which architecture best fits?
Let Claude both invent and approve maintenance actions because one model decision keeps control centralized. The selected method would be used to enforce policy before any maintenance execution.
Your answer is correct
Let Claude propose maintenance actions, then pass each proposal through deterministic policy validation before executor runs. The team would then enforce policy before any maintenance execution based on that assumption before release.
Have peer agents vote on action, then execute the majority choice without checking policy against trusted state. The team would then enforce policy before any maintenance execution based on that assumption.
Put policy text in the prompt and allow the agent to call executor directly. This would become the basis used to enforce policy before any maintenance execution.
Overall explanation
Correct option:

Let Claude propose maintenance actions, then pass each proposal through deterministic policy validation before executor runs. The team would then enforce policy before any maintenance execution based on that assumption before release.

Claude can interpret the variable incident evidence and formulate a candidate action. A deterministic validator can then evaluate the target and timing against trusted policy state. The important point is that the design can enforce policy before any maintenance execution.

Separating proposal from execution prevents model judgment from becoming the authorization boundary. The executor receives only actions that pass the application-owned checks. The implementation can record the result and compare it with the acceptance criteria.

The design also creates an auditable record of the proposal, policy decision, and executed action. Those records let operators distinguish model behavior from enforcement behavior during review. The same evidence can support monitoring, rollback, and later revisions.

Incorrect options:

Let Claude both invent and approve maintenance actions because one model decision keeps control centralized. The selected method would be used to enforce policy before any maintenance execution.

A single model decision can simplify orchestration, but it combines proposal and authorization in one probabilistic step. The allowlist and change window would no longer be machine-enforced boundaries. Reviewers could not use this as evidence that the system will enforce policy before any maintenance execution.

Centralized control is useful only when the controlling component can deterministically enforce policy. Here the model should supply analysis, not approve its own maintenance action. A separate control would still be required before the option could satisfy the requirement.

Have peer agents vote on action, then execute the majority choice without checking policy against trusted state. The team would then enforce policy before any maintenance execution based on that assumption.

Peer voting may reduce reliance on one model response, but agreement does not prove that an action satisfies current policy. All peers can endorse a target outside the allowlist or an action outside the change window. This would not reliably enforce policy before any maintenance execution.

Trusted system state must be checked by application logic before execution. A majority vote is not a substitute for that policy evaluation. The team could not use this choice as reliable evidence for release.

Put policy text in the prompt and allow the agent to call executor directly. This would become the basis used to enforce policy before any maintenance execution.

Prompting Claude with policy text can improve its proposals, but prompts do not create a deterministic execution gate. The agent could still call the executor with a noncompliant action. The proposed assumption does not help the implementation enforce policy before any maintenance execution.

The application should treat the prompt as behavioral guidance and the validator as enforcement. Direct executor access collapses that distinction. The gap would remain visible during testing or production operation.

References:

https://www.anthropic.com/engineering/building-effective-agents

https://code.claude.com/docs/en/agent-sdk/hooks

https://code.claude.com/docs/en/agent-sdk/permissions
Domain
Agents and Workflows
Question 7Correct
A claims-processing service always performs four known steps: extract fields, validate a schema, compare policy rules, and route exceptions for human approval. Only the policy interpretation step benefits from Claude, and the team requires predictable execution paths, bounded cost, and auditable checkpoints. Which architecture best fits these requirements?
Give an autonomous agent every service tool and let it decide the sequence, completion criteria, and approval timing for each claim. Reviewers would evaluate whether this can separate deterministic controls from bounded model reasoning.
Run several independent agents that vote on every step, including deterministic schema validation. The selected method would be used to separate deterministic controls from bounded model reasoning.
Your answer is correct
Implement a predefined workflow, use Claude only for bounded policy interpretation, and preserve programmatic validation plus human approval. Reviewers would evaluate whether this can separate deterministic controls from bounded model reasoning.
Put all four steps into one prompt and rely on Claude to follow the requested order. The design would use this reasoning to separate deterministic controls from bounded model reasoning.
Overall explanation
Correct option:

Implement a predefined workflow, use Claude only for bounded policy interpretation, and preserve programmatic validation plus human approval. Reviewers would evaluate whether this can separate deterministic controls from bounded model reasoning.

The application has a known sequence, so a predefined workflow supplies the required predictability and auditability. Claude is limited to the interpretation step that actually needs model judgment. The important point is that the design can separate deterministic controls from bounded model reasoning.

Schema validation remains programmatic rather than probabilistic. The human checkpoint stays at the consequential exception decision, where oversight has clear value. The implementation can record the result and compare it with the acceptance criteria.

This design bounds cost and execution while retaining Claude's useful flexibility. It also prevents autonomous choices from replacing fixed controls that the team already understands. The same evidence can support monitoring, rollback, and later revisions.
via - https://www.anthropic.com/engineering/building-effective-agents

Incorrect options:

Give an autonomous agent every service tool and let it decide the sequence, completion criteria, and approval timing for each claim. Reviewers would evaluate whether this can separate deterministic controls from bounded model reasoning.

Agents are appropriate when the model must choose an unpredictable path or number of steps. This service already has a stable four-step process. The proposed assumption does not help the implementation separate deterministic controls from bounded model reasoning.

Giving the agent control over sequence, completion, and approval weakens the required bounds. It also adds unnecessary cost and compounding-error risk. The gap would remain visible during testing or production operation.

Run several independent agents that vote on every step, including deterministic schema validation. The selected method would be used to separate deterministic controls from bounded model reasoning.

Parallel agents can help when independent subtasks benefit from simultaneous work or multiple perspectives. Deterministic schema validation does not require agent voting. The option leaves no dependable way to separate deterministic controls from bounded model reasoning.

Voting on every step multiplies cost and latency without improving the fixed workflow. It also obscures the simple audit trail the team requires. For that reason, the option does not meet the scenario as written.

Put all four steps into one prompt and rely on Claude to follow the requested order. The design would use this reasoning to separate deterministic controls from bounded model reasoning.

A prompt can request an order, but it does not programmatically enforce the workflow. Combining all controls in one generation also makes failures harder to isolate. That approach conflicts with the need to separate deterministic controls from bounded model reasoning.

This option removes explicit schema validation and a durable approval boundary. The service needs orchestration outside the prompt for those guarantees. The implementation would still fail the relevant acceptance or safety check.

References:

https://www.anthropic.com/engineering/building-effective-agents

https://code.claude.com/docs/en/agent-sdk/overview

https://code.claude.com/docs/en/agent-sdk/agent-loop
Domain
Agents and Workflows
Question 8Correct
A support platform has high-volume routine classification and rare policy appeals requiring deeper reasoning. The team must interpret the behavior correctly before changing model settings or request handling. Which model strategy is most defensible?
Choose the least expensive tier that passes one aggregate benchmark across both task families. This would become the basis used to route routine and complex cases cost effectively.
Your answer is correct
Benchmark candidate tiers on representative evals, route by task needs, and retest before model changes. The application would follow this approach to route routine and complex cases cost effectively.
Route by published model descriptions and vendor benchmarks, then skip workload-specific evaluation to avoid delaying the production selection decision. The application would follow this approach to route routine and complex cases cost effectively.
Route by traffic volume, then review appeal quality after the next model release. The selected method would be used to route routine and complex cases cost effectively.
Overall explanation
Correct option:

Benchmark candidate tiers on representative evals, route by task needs, and retest before model changes. The application would follow this approach to route routine and complex cases cost effectively.

Representative evals make quality differences visible for both routine and difficult task families. Latency and cost measurements then support a routing policy grounded in actual requirements. This gives the team a practical way to route routine and complex cases cost effectively.

The likely outcome is a faster, lower-cost tier for validated routine work and a stronger tier for appeals. That routing remains a hypothesis until the evaluation evidence supports it. It also creates an implementation boundary that can be inspected and tested.

Model releases can change behavior even when the interface remains familiar. Retesting prompts and critical evals before migration protects the established quality threshold. The team can compare later releases against the same operational standard.

Incorrect options:

Route by published model descriptions and vendor benchmarks, then skip workload-specific evaluation to avoid delaying the production selection decision. The application would follow this approach to route routine and complex cases cost effectively.

Published descriptions and vendor benchmarks are useful for narrowing the candidate set. They do not measure the platform's own classification labels, policy language, traffic mix, or failure costs. The design would still fail to route routine and complex cases cost effectively.

Skipping workload-specific evaluation turns a reasonable screening step into an unsupported production decision. Representative tests are still needed before selecting or routing models. The missing control would have to be added elsewhere in the design.

Choose the least expensive tier that passes one aggregate benchmark across both task families. This would become the basis used to route routine and complex cases cost effectively.

A quality floor and cost comparison can be part of model selection. One aggregate score can still hide poor performance on the rare appeal cases that need deeper reasoning. Reviewers could not use this as evidence that the system will route routine and complex cases cost effectively.

The two task families should have separate acceptance criteria and representative weighting. Cost optimization is defensible only after each required behavior is visible. A separate control would still be required before the option could satisfy the requirement.

Route by traffic volume, then review appeal quality after the next model release. The selected method would be used to route routine and complex cases cost effectively.

Traffic volume is relevant to throughput and cost planning, but it does not establish the quality required for policy appeals. Delaying appeal review until a later release leaves current high-impact errors unmeasured. The proposed assumption does not help the implementation route routine and complex cases cost effectively.

Lifecycle testing should occur before a model change, not only afterward. Routing needs current task-specific evidence as well as volume data. The gap would remain visible during testing or production operation.

References:

https://platform.claude.com/docs/en/about-claude/models/overview

https://platform.claude.com/docs/en/test-and-evaluate/develop-tests

https://platform.claude.com/docs/en/about-claude/model-deprecations
Domain
Model Selection and Optimization
Question 9Correct
During an invalid-request incident, this wrapper generates a burst of repeated calls. Reviewers want to avoid an optimization that hides the actual cause of the production behavior. Which correction best addresses the defect?

    def send_with_retry(client, params):
       while True:
           try:
               return client.messages.create(**params)
           except Exception:
               continue

Catch every exception, but add a debug log before starting the next immediate attempt. The selected method would be used to avoid retrying requests that cannot succeed unchanged.
Your answer is correct
Classify failures, retry only transient cases with bounded backoff, and surface nonretryable errors. The design would use this reasoning to avoid retrying requests that cannot succeed unchanged.
Remove handling so the process exits whenever a request encounters an error. The selected method would be used to avoid retrying requests that cannot succeed unchanged.
Retry invalid requests using progressively larger payloads because added content will eventually make every malformed request valid. The selected method would be used to avoid retrying requests that cannot succeed unchanged.
Overall explanation
Correct option:

Classify failures, retry only transient cases with bounded backoff, and surface nonretryable errors. The design would use this reasoning to avoid retrying requests that cannot succeed unchanged.

The loop currently treats configuration errors, authentication failures, and transient service conditions alike. Retrying nonretryable errors cannot correct the request and amplifies traffic. The important point is that the design can avoid retrying requests that cannot succeed unchanged.

A sound wrapper classifies failures and uses a finite retry policy for conditions that can plausibly recover. Backoff and jitter help avoid synchronized retry bursts. The implementation can record the result and compare it with the acceptance criteria.

The official SDK already retries selected connection, rate-limit, and server errors by default. Custom logic should complement that behavior and surface terminal failures to the caller. The same evidence can support monitoring, rollback, and later revisions.

Incorrect options:

Catch every exception, but add a debug log before starting the next immediate attempt. The selected method would be used to avoid retrying requests that cannot succeed unchanged.

A log improves observability but does not change the unbounded immediate retry behavior. The service would continue generating load during a persistent invalid request. Reviewers could not use this as evidence that the system will avoid retrying requests that cannot succeed unchanged.

The correction must alter control flow based on error type and attempt count. Logging should support that policy rather than substitute for it. A separate control would still be required before the option could satisfy the requirement.

Remove handling so the process exits whenever a request encounters an error. The selected method would be used to avoid retrying requests that cannot succeed unchanged.

Exiting on every error avoids a retry storm but discards recovery for transient conditions. Short-lived network or capacity failures can succeed under a bounded retry policy. This would not reliably avoid retrying requests that cannot succeed unchanged.

A production service needs both terminal error propagation and controlled resilience. Removing all handling provides only the first of those properties. The team could not use this choice as reliable evidence for release.

Retry invalid requests using progressively larger payloads because added content will eventually make every malformed request valid. The selected method would be used to avoid retrying requests that cannot succeed unchanged.

Increasing an invalid payload does not repair its invalid fields or authorization. It can raise cost and make size-related problems worse. The proposed assumption does not help the implementation avoid retrying requests that cannot succeed unchanged.

The application should inspect the error category and correct the request when human or programmatic intervention is required. Repetition is not remediation. The gap would remain visible during testing or production operation.

References:

https://platform.claude.com/docs/en/api/errors

https://platform.claude.com/docs/en/cli-sdks-libraries/overview

https://platform.claude.com/docs/en/api/rate-limits
Domain
Model Selection and Optimization
Question 10Correct
A team will replace a widely used Claude client wrapper across fifty services. Reviewers need enough evidence to approve the integration and detect failures before users are affected. Which TWO practices most reduce refactoring risk?

    interface ClaudeGateway {
     send(request: Request): Promise<Response>;
    }
    class LegacyGateway implements ClaudeGateway {
     async send(request: Request): Promise<Response> {
       return fetch("/claude", { method: "POST", body: JSON.stringify(request) });
     }
    }

Your selection is correct
Run contract and regression tests while migrating services incrementally with explicit rollback checkpoints between releases. Reviewers would evaluate whether this can replace the wrapper behind a stable interface.
Replace all fifty services and their tests together through one unreviewed migration release. The design would use this reasoning to replace the wrapper behind a stable interface.
Allow each service to reinterpret response fields independently without a shared compatibility contract definition. Reviewers would evaluate whether this can replace the wrapper behind a stable interface.
Delete the legacy implementation before testing parity, forcing every service to adopt the replacement during the first release. The design would use this reasoning to replace the wrapper behind a stable interface.
Your selection is correct
Preserve the gateway interface while introducing a new implementation behind the existing service contract for clients. Reviewers would evaluate whether this can replace the wrapper behind a stable interface.
Overall explanation
Correct options:

Preserve the gateway interface while introducing a new implementation behind the existing service contract for clients. Reviewers would evaluate whether this can replace the wrapper behind a stable interface.

Keeping the gateway contract stable shields client services from replacement details. The team can compare old and new implementations behind the same boundary. This is the mechanism the team needs to replace the wrapper behind a stable interface.

A compatibility layer allows selected services to move without changing their calling code immediately. It also leaves a clear place to translate response differences during the transition. The team can verify the behavior with explicit checks before release.

Reviewers should document the contract invariants before switching implementations. Tests can then run identical requests against both gateways and compare observable behavior. This keeps the production decision traceable when the system changes.

Run contract and regression tests while migrating services incrementally with explicit rollback checkpoints between releases. Reviewers would evaluate whether this can replace the wrapper behind a stable interface.

Contract and regression tests detect changes that would violate existing service expectations. Incremental releases limit exposure while evidence is collected from each migrated group. This gives the team a practical way to replace the wrapper behind a stable interface.

Explicit checkpoints give operators a known point at which to stop or roll back. This sequence makes parity evidence and operational control part of the migration. It also creates an implementation boundary that can be inspected and tested.

A useful rollout record links each cohort to its test results, monitoring window, and fallback decision. That trace supports safe continuation across the remaining services. The team can compare later releases against the same operational standard.

Incorrect options:

Replace all fifty services and their tests together through one unreviewed migration release. The design would use this reasoning to replace the wrapper behind a stable interface.

A simultaneous unreviewed change creates one failure domain across all fifty consumers. When behavior shifts, the team cannot isolate the affected service or revert a small cohort. The design would still fail to replace the wrapper behind a stable interface.

Combining production code and every test in one release also produces an oversized review surface. That approach increases migration risk instead of containing it. The missing control would have to be added elsewhere in the design.

Delete the legacy implementation before testing parity, forcing every service to adopt the replacement during the first release. The design would use this reasoning to replace the wrapper behind a stable interface.

Removing the legacy path before parity is known destroys the fastest recovery mechanism. The first incompatibility would affect every adopter without an implementation fallback. The proposed assumption does not help the implementation replace the wrapper behind a stable interface.

Deletion belongs after the replacement has passed its planned migration window. Doing it first turns a reversible refactor into a forced cutover. The gap would remain visible during testing or production operation.

Allow each service to reinterpret response fields independently without a shared compatibility contract definition. Reviewers would evaluate whether this can replace the wrapper behind a stable interface.

Independent field interpretation lets services assign different meanings to the same response. The migration can then appear successful while downstream behavior diverges silently. The option leaves no dependable way to replace the wrapper behind a stable interface.

A shared compatibility contract is needed to judge the replacement consistently. Local reinterpretation prevents reliable contract testing across the service fleet. For that reason, the option does not meet the scenario as written.

References:

https://platform.claude.com/docs/en/api/messages

https://platform.claude.com/docs/en/cli-sdks-libraries/overview

https://platform.claude.com/docs/en/about-claude/models/migration-guide
Domain
Applications and Integration
Question 11Correct
A tool can repeatedly return the same recoverable error, and the loop below has no operational bound. The team needs clear boundaries for delegation, retries, approvals, and termination. Which change best prevents an unbounded agent run?

    while True:
       response = client.messages.create(**request)
       if response.stop_reason == "end_turn":
           return response
       request = handle_requested_tools(response, request)

Reset conversation after each call so the model cannot observe earlier failures or results. The implementation would treat this as the rule for how to bound retries and escalate repeated failures.
Remove the end_turn check so every response continues through another tool cycle until process is externally terminated. This would become the basis used to bound retries and escalate repeated failures before release.
Treat every tool_use response as final success, even when the requested operation has not executed yet. The application would follow this approach to bound retries and escalate repeated failures.
Your answer is correct
Add a maximum turn or tool-call budget and return a controlled terminal error when exceeded. This would become the basis used to bound retries and escalate repeated failures.
Overall explanation
Correct option:

Add a maximum turn or tool-call budget and return a controlled terminal error when exceeded. This would become the basis used to bound retries and escalate repeated failures.

A turn or tool-call budget places an explicit upper bound on repeated agent cycles. When the repeated tool error consumes that budget, the application can stop predictably. That directly supports the need to bound retries and escalate repeated failures.

Returning a controlled terminal error preserves the reason for termination. Callers can distinguish a limit from successful end_turn completion and choose recovery deliberately. It gives reviewers concrete evidence instead of relying on an informal assumption.

The bound should match the task's expected complexity and operational budget. Monitoring limit hits can reveal a broken tool, unclear prompt, or unsuitable recovery policy. This also reduces ambiguity when the team investigates a regression.

Incorrect options:

Remove the end_turn check so every response continues through another tool cycle until process is externally terminated. This would become the basis used to bound retries and escalate repeated failures before release.

Removing the natural completion check makes the loop less capable of stopping, not more bounded. Even a successful text-only response would be forced into another cycle. The proposed assumption does not help the implementation bound retries and escalate repeated failures.

External process termination is a coarse emergency control and may discard useful result state. The application should define a normal loop limit and handle its outcome explicitly. The gap would remain visible during testing or production operation.

Treat every tool_use response as final success, even when the requested operation has not executed yet. The application would follow this approach to bound retries and escalate repeated failures.

A tool_use response requests an operation rather than reporting final task success. Treating it as complete would abandon requested work and produce a false success state. The option leaves no dependable way to bound retries and escalate repeated failures.

This choice stops early but does not implement a valid termination policy. The loop still needs to distinguish natural completion from reaching a configured bound. For that reason, the option does not meet the scenario as written.

Reset conversation after each call so the model cannot observe earlier failures or results. The implementation would treat this as the rule for how to bound retries and escalate repeated failures.

Resetting history removes the error observations Claude needs to adapt its next action. The model may repeat the same failing call because it cannot see what already happened. The design would still fail to bound retries and escalate repeated failures.

A fresh conversation is not a loop limit unless another component counts the resets. It also weakens diagnosis by discarding the trace. The missing control would have to be added elsewhere in the design.

References:

https://code.claude.com/docs/en/agent-sdk/agent-loop

https://platform.claude.com/docs/en/agents-and-tools/tool-use/build-a-tool-using-agent

https://code.claude.com/docs/en/agent-sdk/hooks
Domain
Agents and Workflows
Question 12Correct
Several services share a production prompt. The team needs reproducible behavior and rapid rollback after a regression. Which configuration design best fits?
Embed one prompt permanently in each binary and discard evaluation records after every deployment cycle. Reviewers would evaluate whether this can version prompts and preserve rollback evidence.
Your answer is correct
Publish immutable prompt versions with evaluations and switch production through a reversible release pointer. The design would use this reasoning to version prompts and preserve rollback evidence.
Fetch the newest unreviewed prompt on every request so changes reach production without a release decision. The design would use this reasoning to version prompts and preserve rollback evidence.
Let every service edit its own prompt independently, without recording which text produced each evaluation result or production response. Reviewers would evaluate whether this can version prompts and preserve rollback evidence.
Overall explanation
Correct option:

Publish immutable prompt versions with evaluations and switch production through a reversible release pointer. The design would use this reasoning to version prompts and preserve rollback evidence.

Immutable prompt versions give each behavior change a stable identity. Linking evaluations to that identity shows which version satisfied the release criteria. In this scenario, that is what allows the team to version prompts and preserve rollback evidence.

A production pointer can move deliberately to the approved version and return quickly to the prior one. All services can resolve the same selected version without editing prompt text in place. This makes the expected behavior easier to measure under production-like conditions.

The release record should include prompt version, evaluation suite version, decision, and deployment time. A rollback exercise can verify that changing the pointer restores the previous prompt consistently. That makes the design easier to audit and maintain over time.

Incorrect options:

Let every service edit its own prompt independently, without recording which text produced each evaluation result or production response. Reviewers would evaluate whether this can version prompts and preserve rollback evidence.

Independent prompt edits make nominally identical services behave differently. Without a version record, the team cannot reproduce which text generated a failed response. The design would still fail to version prompts and preserve rollback evidence.

Evaluation results also lose meaning when they are not linked to the prompt under test. This design prevents a coordinated rollback across services. The missing control would have to be added elsewhere in the design.

Fetch the newest unreviewed prompt on every request so changes reach production without a release decision. The design would use this reasoning to version prompts and preserve rollback evidence.

Fetching the newest draft turns every document edit into an immediate production change. No review or evaluation boundary determines whether that text is fit for release. Reviewers could not use this as evidence that the system will version prompts and preserve rollback evidence.

Because the target moves between requests, a prior good result cannot identify current behavior. The team also lacks a stable version to restore after regression. A separate control would still be required before the option could satisfy the requirement.

Embed one prompt permanently in each binary and discard evaluation records after every deployment cycle. Reviewers would evaluate whether this can version prompts and preserve rollback evidence.

Embedding a prompt can make one binary reproducible, but permanent copies across services hinder coordinated updates. Discarding evaluation records removes the evidence needed to compare releases. This would not reliably version prompts and preserve rollback evidence.

The design has no shared release identity or rapid reversible pointer. Recovery would require rebuilding and redeploying every affected binary. The team could not use this choice as reliable evidence for release.

References:

https://platform.claude.com/docs/en/test-and-evaluate/eval-tool

https://platform.claude.com/docs/en/test-and-evaluate/develop-tests

https://platform.claude.com/docs/en/about-claude/models/migration-guide
Domain
Applications and Integration
Question 13Correct
An agent summarizes supplier web pages and can draft payments through a finance tool. A page may contain hidden instructions that attempt to override the system prompt and submit a payment. The application must preserve useful summarization while preventing untrusted content from causing a consequential action. Which TWO actions should the developer take?
Increase temperature so hidden instructions are less likely to produce the same action repeatedly. The selected method would be used to resist injection and require payment authorization.
Your selection is correct
Place retrieved page content in a clearly delimited untrusted-data section and instruct Claude not to treat it as authority. The selected method would be used to resist injection and require payment authorization.
Give the finance tool read and write access so Claude can correct a malicious payment automatically. The team would then resist injection and require payment authorization based on that assumption.
Move the page text into the system prompt so it receives the strongest instruction priority. The selected method would be used to resist injection and require payment authorization.
Your selection is correct
Require deterministic authorization and human approval before any payment tool call can execute. This would become the basis used to resist injection and require payment authorization.
Overall explanation
Correct options:

Place retrieved page content in a clearly delimited untrusted-data section and instruct Claude not to treat it as authority. The selected method would be used to resist injection and require payment authorization.

The page is third-party content and therefore an indirect prompt-injection source. Marking and structuring it as untrusted data helps Claude distinguish content to summarize from instructions it may follow. In this scenario, that is what allows the team to resist injection and require payment authorization.

Trusted policy remains in the system or application-controlled instruction layer. The retrieved page cannot legitimately replace that policy merely because it contains imperative language. This makes the expected behavior easier to measure under production-like conditions.

This preserves the useful summarization path while reducing instruction-priority confusion. The application should also retain the source and trust label for monitoring and testing. That makes the design easier to audit and maintain over time.

Require deterministic authorization and human approval before any payment tool call can execute. This would become the basis used to resist injection and require payment authorization.

Authorization must be enforced outside the model before the finance action executes. Human approval creates a deliberate checkpoint for a consequential payment. That directly supports the need to resist injection and require payment authorization.

The finance capability should receive only the permissions required for the approved operation. A successful injection then cannot silently convert summarization into an unrestricted payment. It gives reviewers concrete evidence instead of relying on an informal assumption.

This layer remains effective even if the model proposes a harmful tool call. It protects the real-world action rather than relying only on the model to recognize the attack. This also reduces ambiguity when the team investigates a regression.

Incorrect options:

Give the finance tool read and write access so Claude can correct a malicious payment automatically. The team would then resist injection and require payment authorization based on that assumption.

Broad read and write access violates least privilege. It increases the damage possible if an injection influences the model. The option leaves no dependable way to resist injection and require payment authorization.

Claude should not be trusted to repair a malicious payment through the same unrestricted capability. Authorization and approval must constrain the action before execution. For that reason, the option does not meet the scenario as written.

Increase temperature so hidden instructions are less likely to produce the same action repeatedly. The selected method would be used to resist injection and require payment authorization.

Temperature controls output sampling rather than the trust boundary between application instructions and web content. Randomness is not an injection defense. The design would still fail to resist injection and require payment authorization.

The hidden instruction could still be followed on any sample. Greater variability also makes testing and incident reproduction more difficult. The missing control would have to be added elsewhere in the design.

Move the page text into the system prompt so it receives the strongest instruction priority. The selected method would be used to resist injection and require payment authorization.

The system prompt is the trusted instruction layer. Copying attacker-controlled page text into that layer incorrectly grants it higher authority. Reviewers could not use this as evidence that the system will resist injection and require payment authorization.

This design worsens the exact threat in the scenario. Untrusted content should be identified and isolated rather than promoted. A separate control would still be required before the option could satisfy the requirement.

References:

https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/mitigate-jailbreaks

https://www.anthropic.com/engineering/building-effective-agents

https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/reduce-prompt-leak
Domain
Security and Safety
Question 14Correct
An agent repeatedly includes old search results and now cites superseded customer status. The revised approach must preserve relevant context and produce measurable behavior across representative inputs. Which TWO actions most directly improve its active context?
Your selection is correct
Clear stale tool results after carefully preserving verified current authoritative facts and necessary provenance externally. The selected method would be used to remove stale evidence from active context.
Cache the full transcript and add a recency instruction, while leaving conflicting search results in active context. The selected method would be used to remove stale evidence from active context before release.
Summarize the complete transcript periodically while retaining stale status in the summary. Reviewers would evaluate whether this can remove stale evidence from active context.
Your selection is correct
Isolate a verification subtask, then return only its validated findings to the main agent. The team would apply the same decision when it must remove stale evidence from active context.
Keep all results but label the newest entry as authoritative within prompts. The application would follow this approach to remove stale evidence from active context.
Overall explanation
Correct options:

Clear stale tool results after carefully preserving verified current authoritative facts and necessary provenance externally. The selected method would be used to remove stale evidence from active context.

Tool result clearing removes content that no longer contributes to the current task. Preserving the current status and required provenance first prevents the cleanup from destroying essential evidence. This gives the team a practical way to remove stale evidence from active context.

This approach reduces competing facts inside the context window. It also makes the remaining state easier for both the model and developers to inspect. It also creates an implementation boundary that can be inspected and tested.

The application should retain detailed audit history in an external store when policy requires it. Active context and durable records serve different purposes. The team can compare later releases against the same operational standard.

Isolate a verification subtask, then return only its validated findings to the main agent. The team would apply the same decision when it must remove stale evidence from active context.

A fresh verification subtask can operate without the polluted transcript and focus on current evidence. Returning only validated findings limits context growth in the main agent. In this scenario, that is what allows the team to remove stale evidence from active context.

The subtask should receive explicit criteria, trusted sources, and the customer identifier. Its result then becomes a bounded context artifact rather than another raw search dump. This makes the expected behavior easier to measure under production-like conditions.

Isolation does not eliminate the need to update authoritative state. The orchestrator must replace or supersede the outdated status after validation. That makes the design easier to audit and maintain over time.

Incorrect options:

Keep all results but label the newest entry as authoritative within prompts. The application would follow this approach to remove stale evidence from active context.

An authority label can help Claude interpret conflicting material, so this is not a useless step. Keeping every result still consumes attention and leaves obsolete evidence available to influence later reasoning. The design would still fail to remove stale evidence from active context.

The application can represent the verified state directly and store old provenance outside active context. A prompt label alone is weaker than removing content that no longer deserves context space. The missing control would have to be added elsewhere in the design.

Summarize the complete transcript periodically while retaining stale status in the summary. Reviewers would evaluate whether this can remove stale evidence from active context.

Periodic summarization can reduce token volume and preserve continuity. A summary that deliberately carries stale status forward compresses the conflict instead of resolving it. Reviewers could not use this as evidence that the system will remove stale evidence from active context.

Compaction must distinguish current authoritative facts from superseded observations. Otherwise the smaller context can still anchor the agent on the wrong customer state. A separate control would still be required before the option could satisfy the requirement.

Cache the full transcript and add a recency instruction, while leaving conflicting search results in active context. The selected method would be used to remove stale evidence from active context before release.

A recency instruction may improve focus, and caching can reduce the processing cost of a stable prefix. Neither measure removes conflicting search results from the model's active context. The option leaves no dependable way to remove stale evidence from active context.

Cached tokens still occupy context and can affect attention. The workflow needs actual pruning or isolation rather than an instruction layered over polluted history. For that reason, the option does not meet the scenario as written.

References:

https://platform.claude.com/docs/en/build-with-claude/context-editing

https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents

https://code.claude.com/docs/en/sub-agents
Domain
Prompt and Context Engineering
Question 15Correct
A backend service must invoke Claude programmatically, pass structured tool definitions, and process responses without a human interface. The implementation must preserve the required data and execution boundaries under production conditions. Which surface best fits?
Write pending requests into CLAUDE.md files and wait for future Claude Code sessions to discover and execute them. Reviewers would evaluate whether this can send Messages and handle tools programmatically.
Your answer is correct
Use an official Claude SDK in the backend to submit Messages requests, tools, and response handling. The design would use this reasoning to send Messages and handle tools programmatically.
Require an employee to paste each backend request into claude.ai and copy responses manually back. Reviewers would evaluate whether this can send Messages and handle tools programmatically.
Run Claude Desktop on the server and automate pointer clicks for every production request. This would become the basis used to send Messages and handle tools programmatically.
Overall explanation
Correct option:

Use an official Claude SDK in the backend to submit Messages requests, tools, and response handling. The design would use this reasoning to send Messages and handle tools programmatically.

An official SDK gives backend code a supported interface for Messages requests and typed response handling. Tool definitions and returned content blocks can be processed without a human-operated chat surface. In this scenario, that is what allows the team to send Messages and handle tools programmatically.

The service can apply its own authentication, timeouts, retries, and observability around the API call. That matches the requirement for unattended programmatic integration. This makes the expected behavior easier to measure under production-like conditions.

Integration tests should submit a normal message and a tool-enabled message through the same backend boundary. Assertions can verify request construction, response parsing, and tool dispatch behavior. That makes the design easier to audit and maintain over time.

Incorrect options:

Require an employee to paste each backend request into claude.ai and copy responses manually back. Reviewers would evaluate whether this can send Messages and handle tools programmatically.

Manual copy and paste requires an employee for every backend transaction. It cannot provide the unattended, structured contract described in the question. The option leaves no dependable way to send Messages and handle tools programmatically.

The workflow also introduces transcription risk and inconsistent response handling. A consumer service cannot reliably depend on a person operating claude.ai. For that reason, the option does not meet the scenario as written.

Run Claude Desktop on the server and automate pointer clicks for every production request. This would become the basis used to send Messages and handle tools programmatically.

Pointer automation depends on a desktop interface and screen layout rather than the Claude API. UI changes, focus errors, or session state can break requests unpredictably. That approach conflicts with the need to send Messages and handle tools programmatically.

Running a desktop app does not create a supported backend tool contract. The SDK is designed for this programmatic use case. The implementation would still fail the relevant acceptance or safety check.

Write pending requests into CLAUDE.md files and wait for future Claude Code sessions to discover and execute them. Reviewers would evaluate whether this can send Messages and handle tools programmatically.

CLAUDE.md supplies project instructions and context to Claude Code sessions. It is not a durable request queue that executes application traffic on demand. The design would still fail to send Messages and handle tools programmatically.

Future session discovery has no service-level latency or delivery guarantee. Treating instruction files as pending jobs misuses the coding surface. The missing control would have to be added elsewhere in the design.

References:

https://platform.claude.com/docs/en/cli-sdks-libraries/overview

https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview

https://platform.claude.com/docs/en/api/messages/create
Domain
Applications and Integration
Question 16Correct
A support classifier must return exactly one category and a bounded confidence value. The implementation must preserve the required data and execution boundaries under production conditions. Which TWO design changes improve enforceability?

    {
     "type": "object",
     "properties": {
       "category": {"type": "string"},
       "confidence": {"type": "number"}
     }
    }

Describe confidence in prose while accepting every numeric value, including values outside the application's documented scoring interval during validation. The design would use this reasoning to enforce category values and confidence bounds.
Your selection is correct
Constrain category with an enum containing only labels that the application can recognize and process. This would become the basis used to enforce category values and confidence bounds.
Your selection is correct
Require both properties, then validate confidence bounds after parsing, including SDK post-validation when applicable. The selected method would be used to enforce category values and confidence bounds.
Accept any category string and rely on reviewers to notice labels unsupported by the downstream application. The design would use this reasoning to enforce category values and confidence bounds.
Replace confidence with free-form explanatory text that preserves no numeric validation contract whatsoever. The design would use this reasoning to enforce category values and confidence bounds.
Overall explanation
Correct options:

Constrain category with an enum containing only labels that the application can recognize and process. This would become the basis used to enforce category values and confidence bounds.

An enum restricts category to the finite labels implemented by the support application. That constraint turns an informal naming convention into a schema rule. The option therefore enables the implementation to enforce category values and confidence bounds.

Downstream routing can handle every accepted value without a fallback for invented categories. Enum values should be selected and compared with the documented casing behavior in mind. The resulting control can be exercised repeatedly during regression testing.

Schema tests should accept each supported label and reject a representative unsupported value. Application tests should also map every enum member to a real processing branch. Future changes can be reviewed without losing the original reasoning.

Require both properties, then validate confidence bounds after parsing, including SDK post-validation when applicable. The selected method would be used to enforce category values and confidence bounds.

Listing both names in required prevents a structurally valid response from omitting either output. Numeric range checks must occur after parsing because minimum and maximum are not constrained-decoding guarantees. This is the mechanism the team needs to enforce category values and confidence bounds.

Application validation can reject confidence values outside the documented interval. When a supported SDK helper removes unsupported bounds before sending the schema, it validates the response against the original schema afterward. The team can verify the behavior with explicit checks before release.

Boundary tests should cover both endpoints, values just outside them, and objects missing each required property. Those cases verify presence and range at the layers that actually enforce them. This keeps the production decision traceable when the system changes.

Incorrect options:

Accept any category string and rely on reviewers to notice labels unsupported by the downstream application. The design would use this reasoning to enforce category values and confidence bounds.

An unconstrained string permits category values that no downstream branch understands. Human review after generation does not make the machine-readable contract enforceable. The proposed assumption does not help the implementation enforce category values and confidence bounds.

Unsupported labels can reach production before a reviewer notices them. The schema should prevent those values at the response boundary. The gap would remain visible during testing or production operation.

Describe confidence in prose while accepting every numeric value, including values outside the application's documented scoring interval during validation. The design would use this reasoning to enforce category values and confidence bounds.

A prose description communicates intent but does not impose numeric limits on the schema. Values below or above the supported scoring interval could still validate. That approach conflicts with the need to enforce category values and confidence bounds.

The application needs machine-checkable bounds rather than reviewer interpretation. Accepting every number leaves the confidence contract incomplete. The implementation would still fail the relevant acceptance or safety check.

Replace confidence with free-form explanatory text that preserves no numeric validation contract whatsoever. The design would use this reasoning to enforce category values and confidence bounds.

Free-form text cannot be validated as a bounded confidence number. Replacing the field would remove the exact quantitative property the consumer requires. The design would still fail to enforce category values and confidence bounds.

An explanation may be added separately if useful, but it cannot substitute for range constraints. This option weakens both typing and comparability. The missing control would have to be added elsewhere in the design.

References:

https://platform.claude.com/docs/en/build-with-claude/structured-outputs

https://platform.claude.com/docs/en/agents-and-tools/tool-use/define-tools

https://platform.claude.com/docs/en/api/messages/create
Domain
Applications and Integration
Question 17Correct
An MCP server must expose a versioned policy catalog that clients can list and read by URI as context, plus a risk-scoring operation that accepts case details and performs a calculation. The developer wants the primitives to communicate whether each capability supplies data or performs an action. Which design should the developer use?
Your answer is correct
Expose the catalog as a resource and the risk-scoring operation as a tool. Reviewers would evaluate whether this can separate policy resources from risk-scoring tools.
Put the catalog inside the risk tool's description and expose no resource. This would become the basis used to separate policy resources from risk-scoring tools.
Publish both capabilities as prompts because prompts can contain data and request calculations directly. The team would then separate policy resources from risk-scoring tools based on that assumption.
Expose the catalog as a tool and store the risk-scoring operation in a resource URI. The team would apply the same decision when it must separate policy resources from risk-scoring tools.
Overall explanation
Correct option:

Expose the catalog as a resource and the risk-scoring operation as a tool. Reviewers would evaluate whether this can separate policy resources from risk-scoring tools.

The catalog is data that clients must list and read by URI, which matches an MCP resource. The risk score is an executable calculation with case arguments, which matches an MCP tool. This is the mechanism the team needs to separate policy resources from risk-scoring tools.

Resources provide application-controlled contextual data through discovery and read operations. Tools expose model-invokable operations with input schemas and call results. The team can verify the behavior with explicit checks before release.

Using the primitives this way communicates intent and keeps data separate from executable behavior. The catalog and scoring operation can then evolve without overloading descriptions or prompt templates. This keeps the production decision traceable when the system changes.

Incorrect options:

Publish both capabilities as prompts because prompts can contain data and request calculations directly. The team would then separate policy resources from risk-scoring tools based on that assumption.

Prompts are reusable interaction templates rather than general data stores or operation endpoints. They do not satisfy the requested list-and-read resource behavior. The design would still fail to separate policy resources from risk-scoring tools.

A prompt may guide how a capability is used, but it should not replace both primitives. The server needs a resource for data and a tool for execution. The missing control would have to be added elsewhere in the design.

Expose the catalog as a tool and store the risk-scoring operation in a resource URI. The team would apply the same decision when it must separate policy resources from risk-scoring tools.

This option reverses the required semantics. The catalog must be read as contextual data, while the scoring function performs an action. This would not reliably separate policy resources from risk-scoring tools.

Placing executable behavior behind a resource URI does not create a callable tool contract with an input schema. Treating the catalog as a tool also adds an unnecessary invocation. The team could not use this choice as reliable evidence for release.

Put the catalog inside the risk tool's description and expose no resource. This would become the basis used to separate policy resources from risk-scoring tools.

A tool description should explain how and when to use the operation. It should not carry an entire versioned data catalog. The proposed assumption does not help the implementation separate policy resources from risk-scoring tools.

Embedding the catalog increases description size and prevents normal resource discovery. It also couples data updates to the tool definition. The gap would remain visible during testing or production operation.

References:

https://modelcontextprotocol.io/specification/2025-11-25/server/resources

https://modelcontextprotocol.io/specification/2025-11-25/server/tools

https://platform.claude.com/docs/en/docs/agents-and-tools/mcp
Domain
Tools and MCPs
Question 18Correct
A TypeScript prompt builder produces weaker answers as the document collection grows. The team wants a prompt structure that remains clear as the context grows or changes over time. Which revision best follows long-context prompting guidance?

    const prompt = `Question: ${question}` +
     documents.join("\n") +
     "\nAnswer briefly.";

Remove document boundaries and append every source into one long uninterrupted paragraph before producing the final answer. The team would apply the same decision when it must place long documents for reliable retrieval.
Your answer is correct
Place delimited documents first, then put the specific question and response constraints after them. The team would apply the same decision when it must place long documents for reliable retrieval.
Repeat the question between every document so it occupies most of the available context. The selected method would be used to place long documents for reliable retrieval.
Put the response constraints first and omit the question whenever documents are long. The implementation would treat this as the rule for how to place long documents for reliable retrieval.
Overall explanation
Correct option:

Place delimited documents first, then put the specific question and response constraints after them. The team would apply the same decision when it must place long documents for reliable retrieval.

Anthropic recommends placing long documents near the top of a long-context prompt and the query after them. This ordering helps Claude attend to the evidence before answering the specific request. In this scenario, that is what allows the team to place long documents for reliable retrieval.

Clear delimiters separate source material from instructions and reduce ambiguity about which text is data. XML-style tags are one practical option, but consistent descriptive boundaries are the key. This makes the expected behavior easier to measure under production-like conditions.

The final question should still contain explicit output constraints and any citation requirement. The team should evaluate the revision on representative multi-document cases. That makes the design easier to audit and maintain over time.

Incorrect options:

Repeat the question between every document so it occupies most of the available context. The selected method would be used to place long documents for reliable retrieval.

Repeating the question after every document consumes context and can distort the relative importance of sources. It does not improve the organization of the evidence. The option leaves no dependable way to place long documents for reliable retrieval.

A single clear query after the documents is easier to maintain and evaluate. Repetition should have a demonstrated purpose before consuming the token budget. For that reason, the option does not meet the scenario as written.

Remove document boundaries and append every source into one long uninterrupted paragraph before producing the final answer. The team would apply the same decision when it must place long documents for reliable retrieval.

Removing boundaries makes it harder to distinguish documents, metadata, and instructions. Source attribution and conflict resolution also become less reliable. That approach conflicts with the need to place long documents for reliable retrieval.

Long prompts benefit from explicit structure. Delimiters provide that structure without changing the underlying evidence. The implementation would still fail the relevant acceptance or safety check.

Put the response constraints first and omit the question whenever documents are long. The implementation would treat this as the rule for how to place long documents for reliable retrieval.

A response constraint does not tell Claude what question to answer. Long evidence does not make the intended task self-evident. The design would still fail to place long documents for reliable retrieval.

The query belongs after the evidence, where it can direct analysis of the supplied material. Omitting it creates a fundamentally underspecified request. The missing control would have to be added elsewhere in the design.

References:

https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices

https://platform.claude.com/docs/en/build-with-claude/context-windows

https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
Domain
Prompt and Context Engineering
Question 19Correct
Claude returns schema-conforming JSON for a production configuration update. Before applying the change, what should the application do next? Any revision must be evaluated against the same quality and latency criteria before release.
Convert the JSON into prose and trust whichever explanation sounds most confident to an operator. The team would then validate authorization and business rules before execution based on that assumption.
Your answer is correct
Check completion status, validate rules and facts, then authorize the downstream action. This would become the basis used to validate authorization and business rules before execution.
Apply the configuration immediately because strict schema conformance guarantees every target fact and instruction is correct. The design would use this reasoning to validate authorization and business rules before execution before release.
Skip semantic validation whenever all required property names appear in the expected order. The application would follow this approach to validate authorization and business rules before execution.
Overall explanation
Correct option:

Check completion status, validate rules and facts, then authorize the downstream action. This would become the basis used to validate authorization and business rules before execution.

The application should first confirm that generation ended in an acceptable state rather than truncation or refusal. It should then validate the returned values against trusted deployment records and change policy. This is the mechanism the team needs to validate authorization and business rules before execution.

Domain validation can enforce environment identifiers, allowed settings, dependencies, and required evidence. These checks are outside the expressive guarantee of output schema conformance. The team can verify the behavior with explicit checks before release.

Only after those controls pass should the service authorize the downstream configuration change. Audit logging can preserve the model output, validation result, and action decision. This keeps the production decision traceable when the system changes.

Incorrect options:

Apply the configuration immediately because strict schema conformance guarantees every target fact and instruction is correct. The design would use this reasoning to validate authorization and business rules before execution before release.

Schema conformance guarantees shape, not factual truth or deployment correctness. A valid object can still name the wrong environment or contain an unsafe setting. The design would still fail to validate authorization and business rules before execution.

Applying a production configuration is a consequential action that needs application-level controls. The structured output should be treated as validated syntax, not final authority. The missing control would have to be added elsewhere in the design.

Convert the JSON into prose and trust whichever explanation sounds most confident to an operator. The team would then validate authorization and business rules before execution based on that assumption.

Converting structured data to prose discards a useful machine-readable contract. Confidence of wording is not evidence that the decision is correct. This would not reliably validate authorization and business rules before execution.

Operators need verified facts and explicit policy checks. A persuasive explanation can still contain an error. The team could not use this choice as reliable evidence for release.

Skip semantic validation whenever all required property names appear in the expected order. The application would follow this approach to validate authorization and business rules before execution.

Required property names and ordering establish structure rather than semantics. They do not prove that values match the intended environment or approved configuration policy. The proposed assumption does not help the implementation validate authorization and business rules before execution.

The workflow must validate meaning before action. Structured outputs reduce parsing risk but do not replace domain controls. The gap would remain visible during testing or production operation.

References:

https://platform.claude.com/docs/en/build-with-claude/structured-outputs

https://platform.claude.com/docs/en/build-with-claude/handling-stop-reasons

https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/increase-consistency
Domain
Prompt and Context Engineering
Question 20Correct
A Claude service classifies user-submitted support tickets. The classifier needs only the issue text, but the application sends full account histories and stores raw requests indefinitely in a broadly accessible analytics workspace. Which change most directly reduces leakage risk while preserving classification?
Encrypt every raw log at rest while continuing to send complete customer histories to Claude. This would become the basis used to minimize data collection, retention, and access.
Your answer is correct
Remove unneeded fields, redact identifiers, and send only the minimum ticket content required for classification. This would become the basis used to minimize data collection, retention, and access.
Add a system instruction telling Claude never to reveal personal data in classification responses. The design would use this reasoning to minimize data collection, retention, and access.
Retain complete tickets and account histories in a restricted analytics workspace so future reviewers can investigate every classification decision. The application would follow this approach to minimize data collection, retention, and access.
Overall explanation
Correct option:

Remove unneeded fields, redact identifiers, and send only the minimum ticket content required for classification. This would become the basis used to minimize data collection, retention, and access.

Removing fields that are unnecessary for the classification task follows data minimization. Redacting identifiers further reduces the impact if prompts, traces, or outputs are exposed. That directly supports the need to minimize data collection, retention, and access.

This change preserves the issue text that the classifier actually needs. It therefore reduces risk without discarding the evidence required to produce the requested category. It gives reviewers concrete evidence instead of relying on an informal assumption.

The same design should be paired with appropriate retention, access control, and audit practices for any remaining data. Minimizing the request is the most direct control among the listed choices. This also reduces ambiguity when the team investigates a regression.

Incorrect options:

Encrypt every raw log at rest while continuing to send complete customer histories to Claude. This would become the basis used to minimize data collection, retention, and access.

Encryption at rest protects stored data from some unauthorized access paths. It does not justify sending account history that the model does not need for classification. The proposed assumption does not help the implementation minimize data collection, retention, and access.

The raw information would still enter the model request and remain available to the logging system after decryption. Data minimization should reduce exposure before those stages. The gap would remain visible during testing or production operation.

Add a system instruction telling Claude never to reveal personal data in classification responses. The design would use this reasoning to minimize data collection, retention, and access.

A system instruction may influence the generated response, but it does not remove sensitive fields from the request. It also does not prevent the application from retaining raw input in its analytics logs. The option leaves no dependable way to minimize data collection, retention, and access.

Privacy controls should not rely solely on probabilistic compliance when deterministic preprocessing is available. The application can redact and minimize data before Claude receives it. For that reason, the option does not meet the scenario as written.

Retain complete tickets and account histories in a restricted analytics workspace so future reviewers can investigate every classification decision. The application would follow this approach to minimize data collection, retention, and access.

Restricting analytics access is useful, but retaining complete histories preserves a much larger sensitive-data footprint than the task requires. Longer retention also creates more opportunity for accidental or unauthorized disclosure. The design would still fail to minimize data collection, retention, and access.

Reviewability can be maintained with minimized, redacted records and suitable metadata. Keeping every raw field is not necessary to investigate classification quality. The missing control would have to be added elsewhere in the design.

References:

https://platform.claude.com/docs/en/manage-claude/api-and-data-retention

https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/reduce-prompt-leak

https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/mitigate-jailbreaks
Domain
Security and Safety
Question 21Correct
A team states only, “The system should extract invoice fields accurately and respond quickly.” The selected approach must produce clear request, response, and operational behavior across the workflow. Which TWO additions make the requirement testable?
Select the strongest available model and treat its published capability description as the only acceptance threshold. The design would use this reasoning to set measurable release gates for invoice extraction.
Your selection is correct
Specify a maximum end-to-end latency at a stated percentile, production load, and measurement window for the deployed service. Reviewers would evaluate whether this can set measurable release gates for invoice extraction.
Your selection is correct
Define a labeled invoice set, field-level scoring method, and minimum accuracy threshold that must pass before release. Reviewers would evaluate whether this can set measurable release gates for invoice extraction.
Let reviewers approve outputs informally whenever extracted fields appear reasonable during manual inspection sessions. The application would follow this approach to set measurable release gates for invoice extraction.
Require one invoice layout and exclude all intended variations from the evaluation set before release. The design would use this reasoning to set measurable release gates for invoice extraction.
Overall explanation
Correct options:

Define a labeled invoice set, field-level scoring method, and minimum accuracy threshold that must pass before release. Reviewers would evaluate whether this can set measurable release gates for invoice extraction.

A labeled invoice set defines the examples on which extraction quality will be judged. Field-level scoring identifies whether individual required values are correct rather than relying on a vague overall impression. In this scenario, that is what allows the team to set measurable release gates for invoice extraction.

A minimum threshold turns accuracy into a release decision. The same dataset, method, and threshold can be applied to later revisions for regression testing. This makes the expected behavior easier to measure under production-like conditions.

The evaluation should represent the intended invoice distribution and important edge cases. Otherwise a precise score could still describe the wrong workload. That makes the design easier to audit and maintain over time.
via - https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/reduce-latency

Specify a maximum end-to-end latency at a stated percentile, production load, and measurement window for the deployed service. Reviewers would evaluate whether this can set measurable release gates for invoice extraction.

A latency percentile defines which portion of requests must satisfy the bound. It is more operationally meaningful than an unspecified average or the word quickly. The option therefore enables the implementation to set measurable release gates for invoice extraction.

The production load and measurement window establish the conditions under which latency is observed. That prevents a lightly loaded development test from standing in for deployed behavior. The resulting control can be exercised repeatedly during regression testing.

Together the bound and conditions form a repeatable service acceptance criterion. The requirement remains independent of which model or implementation eventually meets it. Future changes can be reviewed without losing the original reasoning.
via - https://platform.claude.com/docs/en/test-and-evaluate/eval-tool

Incorrect options:

Select the strongest available model and treat its published capability description as the only acceptance threshold. The design would use this reasoning to set measurable release gates for invoice extraction.

Model selection is an implementation decision, not a measurable statement of acceptable extraction behavior. A capable model can still fail on the team's document distribution. That approach conflicts with the need to set measurable release gates for invoice extraction.

Published descriptions help identify candidates, but they do not supply the team's scoring rule or threshold. Evaluation evidence must connect the chosen system to the requirement. The implementation would still fail the relevant acceptance or safety check.

Let reviewers approve outputs informally whenever extracted fields appear reasonable during manual inspection sessions. The application would follow this approach to set measurable release gates for invoice extraction.

Human review can capture nuanced failures, but informal approval does not define a stable rubric. Different reviewers may interpret reasonable fields differently. The design would still fail to set measurable release gates for invoice extraction.

A useful qualitative test still needs examples, criteria, and a repeatable rating method. Unstructured impressions cannot determine whether a release passed. The missing control would have to be added elsewhere in the design.

Require one invoice layout and exclude all intended variations from the evaluation set before release. The design would use this reasoning to set measurable release gates for invoice extraction.

Restricting evaluation to one layout can make measurement easier, but it changes the intended input distribution. The resulting score would not cover the invoice variations the service must handle. Reviewers could not use this as evidence that the system will set measurable release gates for invoice extraction.

Requirements should measure the real workload rather than remove its difficult cases. Representative layouts and edge cases belong in the labeled set. A separate control would still be required before the option could satisfy the requirement.

References:

https://platform.claude.com/docs/en/test-and-evaluate/develop-tests

https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/reduce-latency

https://platform.claude.com/docs/en/test-and-evaluate/eval-tool
Domain
Applications and Integration
Question 22Correct
A team needs durable state, explicit transition rules, resumable human approvals, and visual inspection of every workflow branch. The workflow should use model discretion only where it adds value to the stated task. Which approach best fits?
Your answer is correct
Use a state-graph framework that models transitions, durable checkpoints, approval pauses, and resumable execution as state. This would become the basis used to persist state, approvals, and resumable checkpoints.
Use a stateless tool loop and reconstruct prior workflow decisions from logs after an interruption. This would become the basis used to persist state, approvals, and resumable checkpoints.
Launch independent agents for each branch without recording dependencies, completed transitions, or approval state. The team would then persist state, approvals, and resumable checkpoints based on that assumption.
Use one prompt that asks Claude to remember stages, approvals, and branch state without durable checkpoints or transitions. Reviewers would evaluate whether this can persist state, approvals, and resumable checkpoints.
Overall explanation
Correct option:

Use a state-graph framework that models transitions, durable checkpoints, approval pauses, and resumable execution as state. This would become the basis used to persist state, approvals, and resumable checkpoints.

A state graph represents each stage and allowed transition explicitly. Durable checkpoints preserve the current node and relevant state across interruption. That directly supports the need to persist state, approvals, and resumable checkpoints.

An approval pause can be modeled as a transition that waits for an external decision. Resumption then follows the recorded branch instead of relying on model memory. It gives reviewers concrete evidence instead of relying on an informal assumption.

The graph also gives reviewers a visible representation of possible paths and terminal states. Framework selection is justified here by the required durability and inspection features. This also reduces ambiguity when the team investigates a regression.

Incorrect options:

Use a stateless tool loop and reconstruct prior workflow decisions from logs after an interruption. This would become the basis used to persist state, approvals, and resumable checkpoints.

Application logs are valuable evidence, but a stateless loop does not make those records executable workflow state. Recovery would require custom reconstruction before the process could resume safely. The proposed assumption does not help the implementation persist state, approvals, and resumable checkpoints.

The team needs checkpoints and explicit transitions during normal operation. Post-interruption log parsing supplies observation without the required state machine. The gap would remain visible during testing or production operation.

Use one prompt that asks Claude to remember stages, approvals, and branch state without durable checkpoints or transitions. Reviewers would evaluate whether this can persist state, approvals, and resumable checkpoints.

A prompt can describe stages and approvals, but conversational recall is not a durable checkpoint. It cannot guarantee that an interrupted run resumes from an authorized transition. The option leaves no dependable way to persist state, approvals, and resumable checkpoints.

The branching structure also remains implicit inside text rather than available for visual inspection. The required control properties belong in the orchestration layer. For that reason, the option does not meet the scenario as written.

Launch independent agents for each branch without recording dependencies, completed transitions, or approval state. The team would then persist state, approvals, and resumable checkpoints based on that assumption.

Independent agents can explore branches concurrently, but they do not automatically record dependencies or completed transitions. One branch may proceed without the approval or state produced by another. The design would still fail to persist state, approvals, and resumable checkpoints.

The requirement is coordinated durable execution rather than isolated exploration. A shared state model must govern when each branch is eligible to run. The missing control would have to be added elsewhere in the design.

References:

https://www.anthropic.com/engineering/building-effective-agents

https://code.claude.com/docs/en/agent-sdk/agent-loop

https://platform.claude.com/docs/en/managed-agents/multiagent-orchestration
Domain
Agents and Workflows
Question 23Correct
A team chooses Claude Managed Agents with asynchronous sessions and an attached preference memory store. The workflow should use model discretion only where it adds value to the stated task. Which deployment characteristic does this choice most directly indicate?
The application must run every loop inside its web process and independently build persistence, scheduling, isolation, and scaling. The application would follow this approach to combine asynchronous sessions with durable preference memory.
The client connection must remain open until all long-running work finishes synchronously in one request. The application would follow this approach to combine asynchronous sessions with durable preference memory.
Managed sessions cannot expose tools because asynchronous execution supports only final text responses from Claude models. The design would use this reasoning to combine asynchronous sessions with durable preference memory.
Your answer is correct
Anthropic hosts the managed agent harness, including asynchronous sessions and attached scoped memory store. This would become the basis used to combine asynchronous sessions with durable preference memory.
Overall explanation
Correct option:

Anthropic hosts the managed agent harness, including asynchronous sessions and attached scoped memory store. This would become the basis used to combine asynchronous sessions with durable preference memory.

Claude Managed Agents supplies a harness that runs in Anthropic-managed infrastructure. The team does not need to keep its own request process alive for the entire asynchronous session. In this scenario, that is what allows the team to combine asynchronous sessions with durable preference memory.

An attached memory store provides durable state that the managed session can access within its configured scope. Session execution and memory remain distinct resources with explicit identifiers. This makes the expected behavior easier to measure under production-like conditions.

The application still starts work, observes status, and consumes results through the service interface. Managed hosting changes runtime ownership rather than eliminating application responsibilities. That makes the design easier to audit and maintain over time.

Incorrect options:

The application must run every loop inside its web process and independently build persistence, scheduling, isolation, and scaling. The application would follow this approach to combine asynchronous sessions with durable preference memory.

Running the loop inside the application's web process describes a self-hosted design. That design makes the team responsible for scheduling, process isolation, persistence, and scaling. The option leaves no dependable way to combine asynchronous sessions with durable preference memory.

The scenario explicitly selects a managed harness for asynchronous work. Rebuilding the whole runtime inside the web service would discard the selected deployment model. For that reason, the option does not meet the scenario as written.

Managed sessions cannot expose tools because asynchronous execution supports only final text responses from Claude models. The design would use this reasoning to combine asynchronous sessions with durable preference memory.

Asynchronous execution describes when work completes, not whether the agent can use tools. Managed agents can operate with configured tools and environments during a session. That approach conflicts with the need to combine asynchronous sessions with durable preference memory.

A final text response is only one possible result of the harness. Tool access is governed by the agent configuration and permissions. The implementation would still fail the relevant acceptance or safety check.

The client connection must remain open until all long-running work finishes synchronously in one request. The application would follow this approach to combine asynchronous sessions with durable preference memory.

An asynchronous session is designed to outlive one continuously open client request. The client can submit work and later inspect the session or receive its result. The design would still fail to combine asynchronous sessions with durable preference memory.

Requiring synchronous completion would defeat the long-running execution model. Connection lifetime and session lifetime are separate concerns. The missing control would have to be added elsewhere in the design.

References:

https://platform.claude.com/docs/en/managed-agents/overview

https://platform.claude.com/docs/en/managed-agents/environments

https://platform.claude.com/docs/en/managed-agents/memory
Domain
Agents and Workflows
Question 24Correct
A support agent should remember a customer's communication preference across separate sessions without retaining raw transcripts. Every autonomous step must remain inspectable and subject to the required operational controls. What design best fits?
Replay full transcripts in every session, retaining unrelated customer details merely to recover one communication preference. The application would follow this approach to remember preferences without retaining raw transcripts.
Place every customer's preferences in one shared memory record available to all support sessions. The design would use this reasoning to remember preferences without retaining raw transcripts.
Expect Claude to recall earlier sessions without attaching saved memory or resupplying relevant prior state. Reviewers would evaluate whether this can remember preferences without retaining raw transcripts.
Your answer is correct
Store the validated preference in customer-scoped memory, and begin each support session with a fresh conversational context. The application would follow this approach to remember preferences without retaining raw transcripts.
Overall explanation
Correct option:

Store the validated preference in customer-scoped memory, and begin each support session with a fresh conversational context. The application would follow this approach to remember preferences without retaining raw transcripts.

Customer-scoped memory preserves the validated preference beyond one session without importing a full transcript. The scope ties the durable fact to the correct customer. This is the mechanism the team needs to remember preferences without retaining raw transcripts.

Starting with fresh conversational context avoids carrying stale task details into a new support interaction. The application can retrieve only the preference needed for the current session. The team can verify the behavior with explicit checks before release.

Validation matters because persistent memory can amplify an incorrect inference across later sessions. The service should store the confirmed preference and retain provenance appropriate to its policy. This keeps the production decision traceable when the system changes.

Incorrect options:

Replay full transcripts in every session, retaining unrelated customer details merely to recover one communication preference. The application would follow this approach to remember preferences without retaining raw transcripts.

A transcript may contain the preference, but it also carries unrelated personal details and obsolete conversation state. Replaying it increases both context size and retained data. The design would still fail to remember preferences without retaining raw transcripts.

The durable fact is compact enough to store directly after validation. Raw history is unnecessary for satisfying this cross-session requirement. The missing control would have to be added elsewhere in the design.

Expect Claude to recall earlier sessions without attaching saved memory or resupplying relevant prior state. Reviewers would evaluate whether this can remember preferences without retaining raw transcripts.

Separate sessions do not implicitly recover facts that the application never supplies or stores. Claude can use only the context and attached resources available to the current run. This would not reliably remember preferences without retaining raw transcripts.

Relying on unsupported recall would make behavior unpredictable and unauditable. The preference requires an explicit persistence mechanism. The team could not use this choice as reliable evidence for release.

Place every customer's preferences in one shared memory record available to all support sessions. The design would use this reasoning to remember preferences without retaining raw transcripts.

One global record breaks isolation between unrelated customers. A session could retrieve another customer's preference or expose information across accounts. The proposed assumption does not help the implementation remember preferences without retaining raw transcripts.

Memory should be keyed and authorized at the same customer boundary used by the application. Shared infrastructure does not require shared logical records. The gap would remain visible during testing or production operation.

References:

https://platform.claude.com/docs/en/managed-agents/memory

https://platform.claude.com/docs/en/managed-agents/overview

https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
Domain
Agents and Workflows
Question 25Correct
A repository has a stable release-review procedure expressed entirely as instructions. The team wants Claude Code to discover the procedure for matching tasks and load its details only when relevant. No external system access is needed. Which customization best fits?
Your answer is correct
Create a project Skill that Claude can discover and load only for relevant tasks. The design would use this reasoning to load reusable instructions only when relevant.
Add the instructions to every prompt so Claude always receives the complete procedure before each task. The selected method would be used to load reusable instructions only when relevant.
Implement a custom API tool that returns the static procedure and requires application-side execution on every relevant task. Reviewers would evaluate whether this can load reusable instructions only when relevant.
Deploy an MCP server that exposes the procedure through a remote tool and loads its description into every session. The selected method would be used to load reusable instructions only when relevant.
Overall explanation
Correct option:

Create a project Skill that Claude can discover and load only for relevant tasks. The design would use this reasoning to load reusable instructions only when relevant.

A project Skill stores specialized instructions with metadata that helps Claude decide when the capability is relevant. Claude can discover the Skill and load its detailed content when needed. The important point is that the design can load reusable instructions only when relevant.

Project scope also allows the repository to share the procedure with the team. The guidance remains close to the codebase and can evolve through normal version control. The implementation can record the result and compare it with the acceptance criteria.

This choice meets the requirement without adding an external execution surface. It also avoids placing the entire procedure into every unrelated prompt. The same evidence can support monitoring, rollback, and later revisions.

Incorrect options:

Add the instructions to every prompt so Claude always receives the complete procedure before each task. The selected method would be used to load reusable instructions only when relevant.

Repeating the full procedure in every prompt can work, but it consumes context even when the procedure is unrelated. It also requires users to remember and maintain the repeated text. The proposed assumption does not help the implementation load reusable instructions only when relevant.

The requirement calls for discoverable reusable guidance with conditional loading. A project Skill packages that behavior more directly than prompt duplication. The gap would remain visible during testing or production operation.

Implement a custom API tool that returns the static procedure and requires application-side execution on every relevant task. Reviewers would evaluate whether this can load reusable instructions only when relevant.

Custom API tools are appropriate when the application needs Claude to request executable client-side behavior. Returning a static procedure through execution adds a tool loop without an operational need. The option leaves no dependable way to load reusable instructions only when relevant.

The procedure is instruction content, not an external action or dynamic lookup. A Skill expresses that content with less infrastructure and clearer intent. For that reason, the option does not meet the scenario as written.

Deploy an MCP server that exposes the procedure through a remote tool and loads its description into every session. The selected method would be used to load reusable instructions only when relevant.

MCP is valuable for standardized connections to external data, tools, and workflows across clients. This scenario has no external integration or independently deployed service requirement. That approach conflicts with the need to load reusable instructions only when relevant.

A remote server would add deployment, authentication, and tool-context considerations to a static instruction problem. Those costs do not advance the stated goal. The implementation would still fail the relevant acceptance or safety check.

References:

https://docs.anthropic.com/en/docs/claude-code/skills

https://docs.anthropic.com/en/docs/agents-and-tools/mcp

https://docs.anthropic.com/en/docs/agents-and-tools/tool-use/implement-tool-use
Domain
Tools and MCPs
Question 26Correct
A REST endpoint expects tags as an array of strings. The implementation must preserve the required data and execution boundaries under production conditions. Which defect appears in this payload?

    {
     "title": "Quarterly report",
     "tags": "finance,review",
     "priority": 2
    }

The priority value must be quoted because REST request bodies permit strings but reject every numeric JSON value. The design would use this reasoning to validate request fields against the endpoint schema.
Your answer is correct
The tags property contains one comma-separated string instead of the required array containing separate string values. The application would follow this approach to validate request fields against the endpoint schema.
The title is invalid because JSON strings cannot contain spaces between words in their values. Reviewers would evaluate whether this can validate request fields against the endpoint schema.
The object needs trailing commas after each property to remain compatible with REST servers. The selected method would be used to validate request fields against the endpoint schema.
Overall explanation
Correct option:

The tags property contains one comma-separated string instead of the required array containing separate string values. The application would follow this approach to validate request fields against the endpoint schema.

The contract requires an array, but the payload supplies one string containing a comma. A server cannot treat that scalar as two array elements without undocumented coercion. In this scenario, that is what allows the team to validate request fields against the endpoint schema.

The corrected property would use a JSON array such as two separate string values. Contract tests should reject the displayed scalar and accept the array form. This makes the expected behavior easier to measure under production-like conditions.

Matching JSON types matters independently of whether the text looks list-like to a person. The comma has no structural meaning while it remains inside quotation marks. That makes the design easier to audit and maintain over time.

Incorrect options:

The title is invalid because JSON strings cannot contain spaces between words in their values. Reviewers would evaluate whether this can validate request fields against the endpoint schema.

Spaces are ordinary characters inside a JSON string value. The title is syntactically valid and does not conflict with the endpoint contract described in the stem. The option leaves no dependable way to validate request fields against the endpoint schema.

Changing the title would leave the actual tags type mismatch untouched. This diagnosis points to a legal value rather than the defective property. For that reason, the option does not meet the scenario as written.

The priority value must be quoted because REST request bodies permit strings but reject every numeric JSON value. The design would use this reasoning to validate request fields against the endpoint schema.

JSON has a native number type, so the unquoted priority value is valid syntax. REST request bodies do not universally restrict primitive values to strings. That approach conflicts with the need to validate request fields against the endpoint schema.

Quoting the number would change its type and could create a second contract violation. Nothing in the scenario says priority is expected as text. The implementation would still fail the relevant acceptance or safety check.

The object needs trailing commas after each property to remain compatible with REST servers. The selected method would be used to validate request fields against the endpoint schema.

Trailing commas are not required to make a JSON object compatible with REST. Standard JSON rejects a comma after the final property. The design would still fail to validate request fields against the endpoint schema.

Adding them would damage a payload that currently parses successfully. Parsing success is separate from the tags schema mismatch the endpoint will detect. The missing control would have to be added elsewhere in the design.

References:

https://platform.claude.com/docs/en/build-with-claude/structured-outputs

https://platform.claude.com/docs/en/api/messages

https://platform.claude.com/docs/en/api/messages/create
Domain
Applications and Integration
Question 27Correct
A new classifier passed offline tests but may behave differently on live traffic. Reviewers need enough evidence to approve the integration and detect failures before users are affected. Which next step best limits operational risk?
Release globally, then define rollback thresholds only after users report harmful production behavior patterns. The design would use this reasoning to control staged rollout, monitoring, and rollback.
Replace the production classifier globally because offline evaluations already prove behavior under every live traffic condition. The design would use this reasoning to control staged rollout, monitoring, and rollback.
Your answer is correct
Release to a small monitored cohort with predefined rollback thresholds, then expand only when live validation meets criteria. The selected method would be used to control staged rollout, monitoring, and rollback.
Keep the classifier offline until every conceivable input and integration condition has been exhaustively tested. Reviewers would evaluate whether this can control staged rollout, monitoring, and rollback.
Overall explanation
Correct option:

Release to a small monitored cohort with predefined rollback thresholds, then expand only when live validation meets criteria. The selected method would be used to control staged rollout, monitoring, and rollback.

A limited cohort bounds exposure while the team observes the classifier on real integrations and traffic. Monitoring can compare live quality and operational metrics with the offline baseline. The important point is that the design can control staged rollout, monitoring, and rollback.

Predefined rollback thresholds turn observed regressions into an immediate release decision. The team does not need to invent its tolerance after users are already affected. The implementation can record the result and compare it with the acceptance criteria.

Expansion should occur only when the monitored evidence satisfies the stated criteria. This creates a controlled sequence from offline validation to broader production use. The same evidence can support monitoring, rollback, and later revisions.

via - https://platform.claude.com/docs/en/test-and-evaluate/develop-tests

Incorrect options:

Replace the production classifier globally because offline evaluations already prove behavior under every live traffic condition. The design would use this reasoning to control staged rollout, monitoring, and rollback.

Offline evaluations are necessary evidence, but they cannot reproduce every dependency, request mix, or production condition. A global replacement exposes the entire population to any missed regression. Reviewers could not use this as evidence that the system will control staged rollout, monitoring, and rollback.

The classifier may ultimately be ready for broad use, but the rollout should test that assumption with bounded exposure. Prior evaluation does not eliminate lifecycle risk. A separate control would still be required before the option could satisfy the requirement.

Keep the classifier offline until every conceivable input and integration condition has been exhaustively tested. Reviewers would evaluate whether this can control staged rollout, monitoring, and rollback.

Expanding the test set is useful when important gaps are known, but every possible input and integration state cannot be enumerated. An exhaustive completion condition can postpone learning indefinitely. This would not reliably control staged rollout, monitoring, and rollback.

A staged production release supplies additional evidence under controlled risk. It complements rather than abandons representative offline testing. The team could not use this choice as reliable evidence for release.

Release globally, then define rollback thresholds only after users report harmful production behavior patterns. The design would use this reasoning to control staged rollout, monitoring, and rollback.

A global release makes every user part of the initial experiment. Waiting for reports also delays detection of failures that monitoring could identify earlier. The proposed assumption does not help the implementation control staged rollout, monitoring, and rollback.

Rollback criteria are most useful when agreed before the release. Defining them after harm creates inconsistent decisions and slower recovery. The gap would remain visible during testing or production operation.

References:

https://platform.claude.com/docs/en/test-and-evaluate/develop-tests

https://platform.claude.com/docs/en/about-claude/models/migration-guide

https://platform.claude.com/docs/en/test-and-evaluate/eval-tool
Domain
Applications and Integration
Question 28Correct
Claude returns stop_reason tool_use and one client tool_use block. The team needs a schema and execution path that can be validated before any external action occurs. What should the application do next in the standard tool-use loop?
Send the identical assistant response back to Claude until stop_reason changes from tool_use to end_turn. The application would follow this approach to execute the client tool and return results.
Treat the tool_use block as final text and show its JSON arguments directly to the user. The application would follow this approach to execute the client tool and return results.
Execute every available tool concurrently, then append all outputs to the original assistant message before resubmitting it. Reviewers would evaluate whether this can execute the client tool and return results before release.
Your answer is correct
Run the named tool, then return a user tool_result block that references the tool_use_id. This would become the basis used to execute the client tool and return results.
Overall explanation
Correct option:

Run the named tool, then return a user tool_result block that references the tool_use_id. This would become the basis used to execute the client tool and return results.

For a client tool, the application owns execution after Claude returns a tool_use block. It should validate the request, run the named operation, and capture the result or error. That directly supports the need to execute the client tool and return results.

The application then sends a user message containing a tool_result block tied to the original tool_use identifier. That association tells Claude which pending request the observation satisfies. It gives reviewers concrete evidence instead of relying on an informal assumption.

A subsequent Messages API call lets Claude use the result, request another tool, or finish its answer. This repeating exchange forms the standard client-side tool loop. This also reduces ambiguity when the team investigates a regression.

Incorrect options:

Treat the tool_use block as final text and show its JSON arguments directly to the user. The application would follow this approach to execute the client tool and return results.

A tool_use block is a request for the application to perform an operation. Showing its arguments as final user-facing text leaves the requested operation unexecuted. The proposed assumption does not help the implementation execute the client tool and return results.

The block may be logged or displayed for review when appropriate, but that is separate from completing the tool loop. The application must either execute or safely reject the call. The gap would remain visible during testing or production operation.

Send the identical assistant response back to Claude until stop_reason changes from tool_use to end_turn. The application would follow this approach to execute the client tool and return results.

Repeating the same assistant response provides no observation from the requested tool. Claude lacks the result needed to decide whether to continue or answer. The option leaves no dependable way to execute the client tool and return results.

The API is driven by conversation content, not by polling the same message until metadata changes. A tool_result supplies the missing state transition. For that reason, the option does not meet the scenario as written.

Execute every available tool concurrently, then append all outputs to the original assistant message before resubmitting it. Reviewers would evaluate whether this can execute the client tool and return results before release.

The application should execute only the calls Claude actually requested and that policy permits. Running every available tool creates unnecessary actions and violates least privilege. The design would still fail to execute the client tool and return results.

Tool results belong in a new user message with the documented content-block structure. Appending outputs to the earlier assistant message changes the conversation incorrectly. The missing control would have to be added elsewhere in the design.

References:

https://docs.anthropic.com/en/docs/agents-and-tools/tool-use/implement-tool-use

https://docs.anthropic.com/en/docs/agents-and-tools/tool-use/bash-tool

https://docs.anthropic.com/en/api/handling-stop-reasons
Domain
Tools and MCPs
Question 29Correct
A product brief says the assistant must classify tickets and that the service must remain available during one regional outage. The team wants a production design that can be tested, monitored, and supported without changing the stated behavior. How should these requirements be classified?
Treat ticket classification as infrastructure and regional fault tolerance as functional product behavior instead. The team would then assign ownership and design separate acceptance tests based on that assumption.
Classify both statements as functional requirements because each one affects the customer experience during service use. Reviewers would evaluate whether this can assign ownership and design separate acceptance tests.
Your answer is correct
Treat ticket classification as functional behavior, and treat regional outage tolerance as a separate infrastructure availability constraint. The selected method would be used to assign ownership and design separate acceptance tests.
Classify both statements as infrastructure requirements because deployed architecture supports each capability in production. The design would use this reasoning to assign ownership and design separate acceptance tests.
Overall explanation
Correct option:

Treat ticket classification as functional behavior, and treat regional outage tolerance as a separate infrastructure availability constraint. The selected method would be used to assign ownership and design separate acceptance tests.

Ticket classification states the function the assistant must perform. Its acceptance criteria can evaluate whether intended tickets receive the required labels. In this scenario, that is what allows the team to assign ownership and design separate acceptance tests.

Regional outage tolerance states an availability constraint that the service architecture must satisfy. It influences redundancy, routing, and failure handling rather than the classification prompt alone. This makes the expected behavior easier to measure under production-like conditions.

Separating the categories lets the team validate product behavior and operational resilience with different tests. Both requirements remain important without being conflated. That makes the design easier to audit and maintain over time.


via - https://platform.claude.com/docs/en/test-and-evaluate/develop-tests

Incorrect options:

Classify both statements as functional requirements because each one affects the customer experience during service use. Reviewers would evaluate whether this can assign ownership and design separate acceptance tests.

Both requirements affect users, but user impact does not determine the requirement category. Classification describes a capability, while outage tolerance constrains how the service operates. The design would still fail to assign ownership and design separate acceptance tests.

Combining them as functional requirements would hide the architectural work needed for regional resilience. Each statement should be assigned to the design concern it governs. The missing control would have to be added elsewhere in the design.

Classify both statements as infrastructure requirements because deployed architecture supports each capability in production. The design would use this reasoning to assign ownership and design separate acceptance tests.

Infrastructure supports the classifier, but that does not make ticket classification an infrastructure requirement. The brief is specifying what the assistant must do with a ticket. Reviewers could not use this as evidence that the system will assign ownership and design separate acceptance tests.

Regional fault tolerance does constrain deployment architecture and availability. Treating both alike loses the distinction needed for solution planning. A separate control would still be required before the option could satisfy the requirement.

Treat ticket classification as infrastructure and regional fault tolerance as functional product behavior instead. The team would then assign ownership and design separate acceptance tests based on that assumption.

This choice reverses the categories. Ticket classification is observable product behavior, not merely an infrastructure property. This would not reliably assign ownership and design separate acceptance tests.

Regional fault tolerance describes an operational constraint on the deployed service. It does not state a business function performed on a ticket. The team could not use this choice as reliable evidence for release.

References:

https://platform.claude.com/docs/en/test-and-evaluate/develop-tests

https://platform.claude.com/docs/en/api/errors

https://platform.claude.com/docs/en/test-and-evaluate/eval-tool
Domain
Applications and Integration
Question 30Correct
A web application reuses one conversation history for all signed-in users. Users sometimes receive details from other sessions. What is the best correction?
Add a prompt asking Claude to forget identities, while continuing to load the same history for every user. Reviewers would evaluate whether this can isolate conversation state for every user before release.
Increase max_tokens so each response can include more of the shared cross-user conversation history content. The team would apply the same decision when it must isolate conversation state for every user.
Shuffle prior messages before each request so no single user's context remains consistently ordered. The implementation would treat this as the rule for how to isolate conversation state for every user.
Your answer is correct
Store separate histories by authorized user and verify access before loading any conversation into a request. The design would use this reasoning to isolate conversation state for every user.
Overall explanation
Correct option:

Store separate histories by authorized user and verify access before loading any conversation into a request. The design would use this reasoning to isolate conversation state for every user.

Per-user storage creates an explicit boundary between conversation records. An authorization check ensures the requesting identity may load the selected history before it enters a Messages call. In this scenario, that is what allows the team to isolate conversation state for every user.

The request should contain only the current user's relevant turns in the intended order. Server logs can record which authorized history identifier was loaded without copying other tenants' content. This makes the expected behavior easier to measure under production-like conditions.

Isolation tests should create two accounts and attempt both legitimate and cross-account retrieval. The forbidden case must fail before any request is sent to Claude. That makes the design easier to audit and maintain over time.

Incorrect options:

Increase max_tokens so each response can include more of the shared cross-user conversation history content. The team would apply the same decision when it must isolate conversation state for every user.

A larger output allowance does not remove another user's messages from the input. It can instead give the response more room to repeat leaked details. The design would still fail to isolate conversation state for every user.

Tenant isolation must happen before request construction. Token configuration cannot repair a mixed server-side history. The missing control would have to be added elsewhere in the design.

Add a prompt asking Claude to forget identities, while continuing to load the same history for every user. Reviewers would evaluate whether this can isolate conversation state for every user before release.

A forget instruction asks the model to compensate for data that the application should never expose. The unrelated history still enters Claude's context and remains available for generation. Reviewers could not use this as evidence that the system will isolate conversation state for every user.

Prompt wording is not an authorization control. The service must exclude records that the signed-in user is not allowed to read. A separate control would still be required before the option could satisfy the requirement.

Shuffle prior messages before each request so no single user's context remains consistently ordered. The implementation would treat this as the rule for how to isolate conversation state for every user.

Shuffling changes message order but preserves every cross-user detail. It also damages conversational chronology needed for relevant follow-up responses. This would not reliably isolate conversation state for every user.

Random placement cannot establish ownership or access rights. The leakage risk remains while the combined content is supplied. The team could not use this choice as reliable evidence for release.

References:

https://platform.claude.com/docs/en/build-with-claude/working-with-messages

https://platform.claude.com/docs/en/api/messages

https://platform.claude.com/docs/en/manage-claude/api-and-data-retention
Domain
Applications and Integration
Question 31Incorrect
Claude returned a tool_use block with id toolu_123, but the next request receives a validation error. Reviewers need enough evidence to approve the integration and detect failures before users are affected. Which TWO defects are present?

    {
     "role": "user",
     "content": [
       {"type": "text", "text": "Thanks"},
       {
         "type": "tool_result",
         "tool_use_id": "different_id",
         "content": "18 C"
       }
     ]
    }

Correct selection
The tool_result uses different_id instead of the identifier from Claude's preceding tool_use block, so correlation fails during validation. Reviewers would evaluate whether this can match tool results to their tool-use identifiers before release.
Your selection is incorrect
The message is invalid because every tool result requires an explicit temperature parameter. The design would use this reasoning to match tool results to their tool-use identifiers.
The message must use assistant role because Claude initiated the preceding tool request itself. The team would apply the same decision when it must match tool results to their tool-use identifiers.
Correct selection
The text block appears before tool_result, but tool results must come first in user content. The design would use this reasoning to match tool results to their tool-use identifiers.
Your selection is incorrect
The tool_result content is invalid because Messages accepts only nested JSON objects and never plain strings. Reviewers would evaluate whether this can match tool results to their tool-use identifiers.
Overall explanation
Correct options:

The tool_result uses different_id instead of the identifier from Claude's preceding tool_use block, so correlation fails during validation. Reviewers would evaluate whether this can match tool results to their tool-use identifiers before release.

A client tool result must reference the exact identifier from the tool_use block it satisfies. The artifact supplies different_id instead of toolu_123. The important point is that the design can match tool results to their tool-use identifiers.

That mismatch prevents the API from correlating the observation with Claude's pending request. The application should preserve the tool-use identifier without transformation. The implementation can record the result and compare it with the acceptance criteria.

Identifier validation should occur before the continuation request is sent. It can catch stale results, mixed concurrent calls, and accidental cross-request association. The same evidence can support monitoring, rollback, and later revisions.

The text block appears before tool_result, but tool results must come first in user content. The design would use this reasoning to match tool results to their tool-use identifiers.

Tool-result blocks must appear before ordinary text blocks in the user content array. The artifact places Thanks first and the tool result second. In this scenario, that is what allows the team to match tool results to their tool-use identifiers.

Moving tool_result to the beginning produces the documented continuation order. Optional user text can follow after all tool results. This makes the expected behavior easier to measure under production-like conditions.

This ordering becomes especially important when one turn returns several tool results. The application should group those result blocks first before adding commentary. That makes the design easier to audit and maintain over time.

Incorrect options:

The tool_result content is invalid because Messages accepts only nested JSON objects and never plain strings. Reviewers would evaluate whether this can match tool results to their tool-use identifiers.

A tool_result can carry simple string content such as the temperature shown here. It can also use supported structured content when the result requires richer data. Reviewers could not use this as evidence that the system will match tool results to their tool-use identifiers.

The validation error is therefore not caused by the text value 18 C. The identifier and block placement are the actual defects in this artifact. A separate control would still be required before the option could satisfy the requirement.

The message must use assistant role because Claude initiated the preceding tool request itself. The team would apply the same decision when it must match tool results to their tool-use identifiers.

Claude originated the tool_use request in an assistant message, but the application returns tool_result in a user message. The user role represents information supplied back to Claude. This would not reliably match tool results to their tool-use identifiers.

Changing this continuation to assistant would assign the observation to the wrong participant. The role shown in the artifact is correct. The team could not use this choice as reliable evidence for release.

The message is invalid because every tool result requires an explicit temperature parameter. The design would use this reasoning to match tool results to their tool-use identifiers.

Temperature is a top-level generation parameter on models that support it, not a required field inside a tool result. Omitting it from this message object does not invalidate the content block. The option leaves no dependable way to match tool results to their tool-use identifiers.

Adding a sampling parameter would not repair either malformed continuation rule. The application must fix correlation and ordering instead. For that reason, the option does not meet the scenario as written.

References:

https://platform.claude.com/docs/en/agents-and-tools/tool-use/handle-tool-calls

https://platform.claude.com/docs/en/agents-and-tools/tool-use/troubleshooting-tool-use

https://platform.claude.com/docs/en/api/messages/create
Domain
Applications and Integration
Question 32Correct
A team considers installing a third-party Claude Code plugin that requests broad filesystem access. Reviewers need enough evidence to approve the integration and detect failures before users are affected. What should they do before organization-wide rollout?
Your answer is correct
Review its source, publisher, requested permissions, dependencies, and version, then record approval before organization-wide deployment. The team would then review plugin provenance, permissions, and dependencies based on that assumption.
Install the plugin immediately because marketplace publication guarantees trusted code, dependencies, and least-privilege behavior for every release. The implementation would treat this as the rule for how to review plugin provenance, permissions, and dependencies.
Copy the marketplace description into CLAUDE.md and treat it as a complete security assessment. The design would use this reasoning to review plugin provenance, permissions, and dependencies.
Grant the plugin broader filesystem access than requested so later versions never need another permission review. The design would use this reasoning to review plugin provenance, permissions, and dependencies.
Overall explanation
Correct option:

Review its source, publisher, requested permissions, dependencies, and version, then record approval before organization-wide deployment. The team would then review plugin provenance, permissions, and dependencies based on that assumption.

Source, publisher, permission, dependency, and version review addresses both behavior and supply-chain risk. Recording approval creates an auditable organization decision before broad deployment. This gives the team a practical way to review plugin provenance, permissions, and dependencies.

The approved release can be pinned or constrained according to the team's update policy. New versions can then be evaluated against the same criteria before replacing it. It also creates an implementation boundary that can be inspected and tested.

A pilot should verify the plugin in a restricted environment and observe the filesystem operations it actually needs. Organization controls can allow only the reviewed marketplace and release after validation. The team can compare later releases against the same operational standard.

Incorrect options:

Install the plugin immediately because marketplace publication guarantees trusted code, dependencies, and least-privilege behavior for every release. The implementation would treat this as the rule for how to review plugin provenance, permissions, and dependencies.

Marketplace availability does not certify that plugin code or dependencies are safe for every organization. Plugins can execute with the installing user's privileges and therefore require a trust decision. The design would still fail to review plugin provenance, permissions, and dependencies.

Immediate installation skips the review prompted by broad filesystem access. Publication alone cannot guarantee least privilege across future releases. The missing control would have to be added elsewhere in the design.

Grant the plugin broader filesystem access than requested so later versions never need another permission review. The design would use this reasoning to review plugin provenance, permissions, and dependencies.

Granting extra access increases the files and secrets exposed if the plugin is defective or compromised. Avoiding future review is not a valid reason to exceed current needs. Reviewers could not use this as evidence that the system will review plugin provenance, permissions, and dependencies.

Each permission should correspond to a reviewed capability. Version changes that request new access deserve another approval decision. A separate control would still be required before the option could satisfy the requirement.

Copy the marketplace description into CLAUDE.md and treat it as a complete security assessment. The design would use this reasoning to review plugin provenance, permissions, and dependencies.

A marketplace description is promotional metadata rather than an examination of executable code. Copying it into a project instruction file adds no technical evidence about dependencies or access. The proposed assumption does not help the implementation review plugin provenance, permissions, and dependencies.

CLAUDE.md also cannot perform supply-chain verification. The team still needs an independent review and approval record. The gap would remain visible during testing or production operation.

References:

https://code.claude.com/docs/en/discover-plugins

https://code.claude.com/docs/en/plugin-marketplaces

https://code.claude.com/docs/en/permissions
Domain
Applications and Integration
Question 33Correct
A TypeScript service uses the official SDK. Reviewers want to avoid an optimization that hides the actual cause of the production behavior. Which replacement correctly waits for the Messages request before reading its response object?

    const pending = client.messages.create({
     model: selectedModel,
     max_tokens: 256,
     messages: [{ role: "user", content: prompt }]
    });
    console.log(pending.content);

Call JSON.stringify on the unresolved promise before directly accessing its content field asynchronously. Reviewers would evaluate whether this can await the SDK request before reading results.
Your answer is correct
Await client.messages.create, then inspect the resolved message content blocks. Reviewers would evaluate whether this can await the SDK request before reading results.
Read pending.content directly because the SDK blocks until each response has completed. The team would then await the SDK request before reading results based on that assumption.
Wrap the client in a new WebSocket connection and wait for a socket close event. The application would follow this approach to await the SDK request before reading results.
Overall explanation
Correct option:

Await client.messages.create, then inspect the resolved message content blocks. Reviewers would evaluate whether this can await the SDK request before reading results.

Awaiting client.messages.create yields the completed message response. The application can then inspect its typed content blocks and other metadata. In this scenario, that is what allows the team to await the SDK request before reading results.

This follows normal TypeScript promise semantics and the official SDK examples. It also keeps network completion separate from response parsing. This makes the expected behavior easier to measure under production-like conditions.

Production code should additionally handle request errors and verify expected content block types. Those checks occur after the promise resolves or rejects. That makes the design easier to audit and maintain over time.

Incorrect options:

Call JSON.stringify on the unresolved promise before directly accessing its content field asynchronously. Reviewers would evaluate whether this can await the SDK request before reading results.

Serializing a promise does not resolve the underlying network operation. It also does not expose the eventual message content in a reliable form. The design would still fail to await the SDK request before reading results.

The code needs JavaScript promise handling rather than a serialization workaround. Awaiting the SDK call produces the typed response object. The missing control would have to be added elsewhere in the design.

Wrap the client in a new WebSocket connection and wait for a socket close event. The application would follow this approach to await the SDK request before reading results.

The standard Messages SDK call does not require constructing a separate WebSocket. Streaming, when selected, uses documented streaming interfaces rather than this replacement. Reviewers could not use this as evidence that the system will await the SDK request before reading results.

Waiting for a fabricated socket event would not resolve the promise returned by messages.create. The application should use the SDK method directly. A separate control would still be required before the option could satisfy the requirement.

Read pending.content directly because the SDK blocks until each response has completed. The team would then await the SDK request before reading results based on that assumption.

The asynchronous SDK does not make pending.content immediately available on an unresolved promise. Reading that property confuses the promise with its eventual value. This would not reliably await the SDK request before reading results.

This mistake can produce undefined access or a type error before the request completes. The caller must await or otherwise resolve the promise. The team could not use this choice as reliable evidence for release.

References:

https://platform.claude.com/docs/en/cli-sdks-libraries/overview

https://platform.claude.com/docs/en/build-with-claude/working-with-messages

https://platform.claude.com/docs/en/api/messages/create
Domain
Model Selection and Optimization
Question 34Correct
A service rejects some valid requests before calling Claude. Review the sizing logic. Which change most directly fixes the underlying problem?

    def fits_budget(text: str, limit: int) -> bool:
       estimated_tokens = len(text) // 4
       return estimated_tokens < limit
     
    if not fits_budget(document, 80_000):
       raise ValueError("Prompt too large")

Remove budget checking because Claude always truncates oversized inputs without an error. The implementation would treat this as the rule for how to admit requests using the actual token count.
Count alphabetic characters because punctuation never contributes tokens to model input. The application would follow this approach to admit requests using the actual token count.
Increase the character divisor until all rejected documents pass the local check. The selected method would be used to admit requests using the actual token count.
Your answer is correct
Call the token counting endpoint with the actual message structure before enforcing the budget. The selected method would be used to admit requests using the actual token count during release review.
Overall explanation
Correct option:

Call the token counting endpoint with the actual message structure before enforcing the budget. The selected method would be used to admit requests using the actual token count during release review.

The token counting endpoint accepts the same structured inputs used to create a message. It accounts for relevant request components more accurately than a character ratio. This is the mechanism the team needs to admit requests using the actual token count.

The returned input count supports decisions about routing, cost, and context fit before generation. Anthropic notes that the count is still an estimate, but it is the purpose-built mechanism. The team can verify the behavior with explicit checks before release.

The service should count the complete candidate request and reserve space for the intended output. It can then reject, trim, or summarize content according to an explicit policy. This keeps the production decision traceable when the system changes.

via - https://platform.claude.com/docs/en/build-with-claude/token-counting

Incorrect options:

Increase the character divisor until all rejected documents pass the local check. The selected method would be used to admit requests using the actual token count.

Changing the divisor merely substitutes one heuristic for another. Tokenization depends on the actual content and structured request components, so a tuned ratio will still fail on new inputs. The design would still fail to admit requests using the actual token count.

A larger divisor can also allow genuinely oversized requests through the check. That creates less predictable failures instead of reliable budget enforcement. The missing control would have to be added elsewhere in the design.

Remove budget checking because Claude always truncates oversized inputs without an error. The implementation would treat this as the rule for how to admit requests using the actual token count.

Removing budget enforcement does not make oversized requests safe. Context limits and intended output space still constrain what a request can contain. This would not reliably admit requests using the actual token count.

Automatic truncation would also risk dropping important instructions or evidence. The application should manage content deliberately and check the relevant token budget. The team could not use this choice as reliable evidence for release.

Count alphabetic characters because punctuation never contributes tokens to model input. The application would follow this approach to admit requests using the actual token count.

Punctuation and other nonalphabetic content can contribute to tokenization. Counting only letters would produce an even less representative estimate. The proposed assumption does not help the implementation admit requests using the actual token count.

Structured elements such as tools, images, and system content can affect input usage as well. The official counting operation is designed to handle the request structure. The gap would remain visible during testing or production operation.

References:

https://platform.claude.com/docs/en/build-with-claude/token-counting

https://platform.claude.com/docs/en/build-with-claude/context-windows

https://platform.claude.com/docs/en/api/messages/count_tokens
Domain
Model Selection and Optimization
Question 35Correct
A classification service sends the same request to Claude several times and occasionally receives different labels. The decision should be based on observable model behavior, token usage, and documented API semantics. Which explanation best reflects an LLM fundamental?
The Messages API silently rewrites identical user prompts whenever the API key is reused. The team would then guide prompt tuning and response validation based on that assumption.
Your answer is correct
Claude generates tokens probabilistically, so repeated calls can vary even when the input remains unchanged. The team would apply the same decision when it must guide prompt tuning and response validation.
The SDK automatically rotates across model families after each successful request to balance regional service availability. This would become the basis used to guide prompt tuning and response validation.
Claude stores each prior label permanently and deliberately avoids returning that label again. The design would use this reasoning to guide prompt tuning and response validation.
Overall explanation
Correct option:

Claude generates tokens probabilistically, so repeated calls can vary even when the input remains unchanged. The team would apply the same decision when it must guide prompt tuning and response validation.

Large language models generate responses through next-token prediction rather than a deterministic lookup table. Multiple valid continuations can therefore produce different final labels across otherwise similar calls. In this scenario, that is what allows the team to guide prompt tuning and response validation.

The variation does not automatically indicate a transport or SDK defect. An application should judge whether outputs meet the task criteria across a representative evaluation set. This makes the expected behavior easier to measure under production-like conditions.

For a classification workflow, teams can strengthen instructions, add examples, and validate the returned label. They should still measure consistency instead of assuming identical outputs are guaranteed. That makes the design easier to audit and maintain over time.

via - https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/increase-consistency

Incorrect options:

The Messages API silently rewrites identical user prompts whenever the API key is reused. The team would then guide prompt tuning and response validation based on that assumption.

The Messages API does not silently rewrite a prompt merely because an API key is reused. The submitted request content remains controlled by the client application. The option leaves no dependable way to guide prompt tuning and response validation.

Attributing variation to hidden prompt mutation would send debugging toward the wrong layer. The team should inspect sampling behavior, prompt clarity, and validation results instead. For that reason, the option does not meet the scenario as written.

The SDK automatically rotates across model families after each successful request to balance regional service availability. This would become the basis used to guide prompt tuning and response validation.

The SDK does not rotate among unrelated model families after each successful request. The request specifies the model that the application intends to call. That approach conflicts with the need to guide prompt tuning and response validation.

Availability handling can involve retries or explicit fallback logic, but that is separate from ordinary model variation. A developer should verify request parameters before claiming that routing changed. The implementation would still fail the relevant acceptance or safety check.

Claude stores each prior label permanently and deliberately avoids returning that label again. The design would use this reasoning to guide prompt tuning and response validation.

Claude does not permanently remember prior API responses and avoid repeating them. The Messages API is stateless, so the client supplies any conversational history needed for a later call. The design would still fail to guide prompt tuning and response validation.

This explanation also conflicts with normal repeatability, where the same output may occur again. Variation is better understood as a property of probabilistic generation. The missing control would have to be added elsewhere in the design.

References:

https://platform.claude.com/docs/en/about-claude/glossary

https://platform.claude.com/docs/en/build-with-claude/working-with-messages

https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/increase-consistency
Domain
Model Selection and Optimization
Question 36Correct
A nightly job analyzes thousands of documents against the same long policy and does not need immediate responses. The selected approach must balance quality, cost, latency, and predictable response handling. Which TWO changes best target cost?
Stream every response to a browser even though no consumer needs incremental output. The design would use this reasoning to combine prompt caching with asynchronous batch processing.
Send each document synchronously while reordering the policy prefix, which prevents cache reuse across repeated requests. This would become the basis used to combine prompt caching with asynchronous batch processing.
Your selection is correct
Keep the stable policy prefix identical and enable prompt caching at an appropriate breakpoint. The selected method would be used to combine prompt caching with asynchronous batch processing.
Increase every output limit to the maximum before measuring actual response needs. The selected method would be used to combine prompt caching with asynchronous batch processing.
Your selection is correct
Submit requests through Message Batches because the workload accepts asynchronous results. The team would apply the same decision when it must combine prompt caching with asynchronous batch processing.
Overall explanation
Correct options:

Keep the stable policy prefix identical and enable prompt caching at an appropriate breakpoint. The selected method would be used to combine prompt caching with asynchronous batch processing.

Prompt caching can reduce the cost and latency of repeatedly processing a stable prompt prefix. A shared policy is a natural candidate when its content and ordering remain consistent. In this scenario, that is what allows the team to combine prompt caching with asynchronous batch processing.

The breakpoint should cover stable material before document-specific content changes. Cache diagnostics and usage fields can confirm whether the intended prefix is reused. This makes the expected behavior easier to measure under production-like conditions.

Caching does not remove those tokens from the context window. The application must still budget the full prompt and output size. That makes the design easier to audit and maintain over time.

Submit requests through Message Batches because the workload accepts asynchronous results. The team would apply the same decision when it must combine prompt caching with asynchronous batch processing.

Message Batches are designed for large groups of requests that can complete asynchronously. That matches a nightly job without interactive latency requirements. This is the mechanism the team needs to combine prompt caching with asynchronous batch processing.

Batch processing can be combined with prompt caching for additional savings. Cache hits in concurrently processed batches are best effort, so the team should measure actual results. The team can verify the behavior with explicit checks before release.

Batch result handling must preserve each request's custom identifier and terminal status. The job should reconcile successes, errors, and expired entries before publishing output. This keeps the production decision traceable when the system changes.

Incorrect options:

Stream every response to a browser even though no consumer needs incremental output. The design would use this reasoning to combine prompt caching with asynchronous batch processing.

Streaming changes how output is delivered but does not inherently create the requested batch discount. No interactive consumer benefits from partial tokens in this scenario. The option leaves no dependable way to combine prompt caching with asynchronous batch processing.

The job can still use streaming for operational reasons, but it is not the best cost answer given the stated requirements. A batch interface better matches deferred completion. For that reason, the option does not meet the scenario as written.

Send each document synchronously while reordering the policy prefix, which prevents cache reuse across repeated requests. This would become the basis used to combine prompt caching with asynchronous batch processing.

Changing the stable prefix order can prevent cache hits because prompt caching depends on matching the prefix. It also creates needless variation in the request. That approach conflicts with the need to combine prompt caching with asynchronous batch processing.

Synchronous submission ignores the job's tolerance for delayed results. Both aspects work against the available optimizations. The implementation would still fail the relevant acceptance or safety check.

Increase every output limit to the maximum before measuring actual response needs. The selected method would be used to combine prompt caching with asynchronous batch processing.

A maximum output allowance can increase potential usage without evidence that longer responses are needed. It does not optimize the repeated policy input. The design would still fail to combine prompt caching with asynchronous batch processing.

The team should size outputs against observed requirements and quality criteria. Token budgets are most useful when they are intentional. The missing control would have to be added elsewhere in the design.

References:

https://platform.claude.com/docs/en/build-with-claude/prompt-caching

https://platform.claude.com/docs/en/build-with-claude/batch-processing

https://platform.claude.com/docs/en/build-with-claude/context-windows
Domain
Model Selection and Optimization
Question 37Correct
An MCP server exposes the sales tool definition below. The backend requires region, but calls can omit it. Which schema change most directly fixes the MCP definition?

    {
     "name": "get_sales",
     "description": "Returns sales totals.",
     "inputSchema": {
       "type": "object",
       "properties": {
         "region": {"type": "string"}
       }
     }
    }

Rename region to location without changing the schema's required fields. The application would follow this approach to require every backend field in the tool schema.
Add an input example containing region and remove the properties definition from inputSchema entirely instead. The team would then require every backend field in the tool schema based on that assumption.
Your answer is correct
Add a required array containing region while keeping the property definition in inputSchema. The design would use this reasoning to require every backend field in the tool schema.
Expand the description to ask Claude to include region, but leave the JSON Schema structure itself otherwise unchanged. The selected method would be used to require every backend field in the tool schema.
Overall explanation
Correct option:

Add a required array containing region while keeping the property definition in inputSchema. The design would use this reasoning to require every backend field in the tool schema.

JSON Schema uses a required array on an object schema to identify properties that must be present. Adding region to that array makes the MCP tool contract match the backend requirement. The option therefore enables the implementation to require every backend field in the tool schema.

The existing properties entry should remain because it defines region as a string. Required membership and property type describe different parts of the same input contract. The resulting control can be exercised repeatedly during regression testing.

A precise inputSchema helps a client construct valid tool input and allows schema-aware validation to catch omissions. The server should still validate arguments before executing the backend call. Future changes can be reviewed without losing the original reasoning.

Incorrect options:

Rename region to location without changing the schema's required fields. The application would follow this approach to require every backend field in the tool schema.

Renaming the property does not make the replacement property required. The backend would also need to change if it still expects the original region field. The proposed assumption does not help the implementation require every backend field in the tool schema.

A tool schema should express the actual contract rather than hide a missing constraint behind a new name. The defect is the absent required array. The gap would remain visible during testing or production operation.

Expand the description to ask Claude to include region, but leave the JSON Schema structure itself otherwise unchanged. The selected method would be used to require every backend field in the tool schema.

A clearer description can improve Claude's selection and argument behavior. It does not make region structurally required when the JSON Schema omits that constraint. That approach conflicts with the need to require every backend field in the tool schema.

Descriptions guide model behavior, while the schema states the machine-readable contract. Both matter, but only the required array directly fixes this defect. The implementation would still fail the relevant acceptance or safety check.

Add an input example containing region and remove the properties definition from inputSchema entirely instead. The team would then require every backend field in the tool schema based on that assumption.

An example can illustrate a valid call but does not define every mandatory property. Removing properties also discards the declared string type for region. The design would still fail to require every backend field in the tool schema.

Examples are supplemental guidance for complex inputs. They should not replace a valid object schema with explicit properties and requirements. The missing control would have to be added elsewhere in the design.

References:

https://modelcontextprotocol.io/specification/2025-11-25/server/tools

https://platform.claude.com/docs/en/agents-and-tools/tool-use/define-tools

https://platform.claude.com/docs/en/docs/agents-and-tools/mcp
Domain
Tools and MCPs
Question 38Correct
A development team is reviewing this behavior before approving the production implementation. The team wants a production design that can be tested, monitored, and supported without changing the stated behavior. What is the primary problem with the following messages portion of a Messages API request?

    {
     "messages": [
       {"role": "system", "content": "Be concise."},
       {"role": "user", "content": "Summarize this."}
     ]
    }

The request needs two user turns before Claude can generate any assistant response at all. Reviewers would evaluate whether this can place system instructions in the correct field.
The request must begin with assistant content because prefilling is mandatory for every model. The design would use this reasoning to place system instructions in the correct field.
The user content must be an image block because text content is unavailable in Messages requests. Reviewers would evaluate whether this can place system instructions in the correct field.
Your answer is correct
The request puts a starting instruction in messages; instructions that apply from beginning belong in top-level system. This would become the basis used to place system instructions in the correct field.
Overall explanation
Correct option:

The request puts a starting instruction in messages; instructions that apply from beginning belong in top-level system. This would become the basis used to place system instructions in the correct field.

An instruction that applies from the start belongs in the request's top-level system field. Placing system as the first entry in messages is not the documented starting-instruction shape. This is the mechanism the team needs to place system instructions in the correct field.

Some current models support a system-role message partway through a conversation under specific placement rules. That exception requires the message to follow a user turn and does not validate the first entry shown here. The team can verify the behavior with explicit checks before release.

Moving Be concise to top-level system leaves the user turn in messages and expresses the intended scope directly. The application should still follow the feature support of its selected model. This keeps the production decision traceable when the system changes.

Incorrect options:

The user content must be an image block because text content is unavailable in Messages requests. Reviewers would evaluate whether this can place system instructions in the correct field.

Messages requests accept plain text in user content, either as a string or supported text block structure. An image block is required only when the application actually supplies image input. The design would still fail to place system instructions in the correct field.

The shown user text is therefore ordinary valid content. Its modality does not explain the request-shape problem. The missing control would have to be added elsewhere in the design.

The request needs two user turns before Claude can generate any assistant response at all. Reviewers would evaluate whether this can place system instructions in the correct field.

A Messages request can begin with one user turn and receive an assistant response. Two user turns are not a protocol prerequisite. This would not reliably place system instructions in the correct field.

Additional turns are supplied when the application wants conversational history. They are not needed to make this initial summarization request valid. The team could not use this choice as reliable evidence for release.

The request must begin with assistant content because prefilling is mandatory for every model. The design would use this reasoning to place system instructions in the correct field.

An assistant message is not required before the first user request. The API can generate the assistant response from the user content and top-level instructions. The proposed assumption does not help the implementation place system instructions in the correct field.

Prefilling is neither mandatory nor universally supported by current models. It should not be introduced to repair an invalid starting system entry. The gap would remain visible during testing or production operation.

References:

https://platform.claude.com/docs/en/build-with-claude/working-with-messages

https://platform.claude.com/docs/en/about-claude/models/migration-guide

https://platform.claude.com/docs/en/api/messages/create
Domain
Applications and Integration
Question 39Correct
An application receives the following response and the final sentence is incomplete. The selected approach must balance quality, cost, latency, and predictable response handling. What should the application conclude first?

    {
     "content": [{"type": "text", "text": "The policy requires"}],
     "stop_reason": "max_tokens",
     "usage": {"input_tokens": 920, "output_tokens": 80}
    }

The SDK failed to deserialize a tool result and substituted partial text instead. The selected method would be used to detect incomplete output and request continuation.
The input exceeded the context window, so the API discarded every earlier system and user instruction. Reviewers would evaluate whether this can detect incomplete output and request continuation before release.
The model completed naturally, and therefore the unfinished sentence is definitely the intended final answer. The application would follow this approach to detect incomplete output and request continuation.
Your answer is correct
Generation reached the configured output limit, so the text should be treated as incomplete. The team would then detect incomplete output and request continuation based on that assumption.
Overall explanation
Correct option:

Generation reached the configured output limit, so the text should be treated as incomplete. The team would then detect incomplete output and request continuation based on that assumption.

A max_tokens stop reason means generation reached the requested or applicable output limit. The returned text may therefore end before Claude finishes the intended response. That directly supports the need to detect incomplete output and request continuation.

The application should not present or parse the fragment as a complete answer. It can increase the output allowance where appropriate or continue through a documented recovery path. It gives reviewers concrete evidence instead of relying on an informal assumption.

Recovery should still respect the total context and cost budget. The developer should validate the next response before allowing downstream use. This also reduces ambiguity when the team investigates a regression.
via - https://platform.claude.com/docs/en/build-with-claude/handling-stop-reasons

Incorrect options:

The input exceeded the context window, so the API discarded every earlier system and user instruction. Reviewers would evaluate whether this can detect incomplete output and request continuation before release.

The response does not say that all prior instructions were discarded. A context-window problem and an output-token termination are different conditions. The proposed assumption does not help the implementation detect incomplete output and request continuation.

The application should interpret the explicit stop reason before inventing another cause. Additional diagnostics can be considered only after handling that recorded condition. The gap would remain visible during testing or production operation.

The model completed naturally, and therefore the unfinished sentence is definitely the intended final answer. The application would follow this approach to detect incomplete output and request continuation.

A natural completion is represented by an end-turn style stop reason, not max_tokens. The incomplete sentence also provides practical evidence that the content is truncated. The option leaves no dependable way to detect incomplete output and request continuation.

Accepting it as complete could propagate malformed or misleading content downstream. The caller should branch on the returned metadata. For that reason, the option does not meet the scenario as written.

The SDK failed to deserialize a tool result and substituted partial text instead. The selected method would be used to detect incomplete output and request continuation.

Nothing in the response indicates a tool result or deserialization failure. A normal text content block and explicit termination reason are already present. The design would still fail to detect incomplete output and request continuation.

Assuming an SDK substitution would ignore the most direct evidence. The handler should use stop_reason as its first decision point. The missing control would have to be added elsewhere in the design.

References:

https://platform.claude.com/docs/en/build-with-claude/handling-stop-reasons

https://platform.claude.com/docs/en/api/messages

https://platform.claude.com/docs/en/api/messages/create
Domain
Model Selection and Optimization
Question 40Correct
A Claude Agent SDK TypeScript PreToolUse callback should block an unapproved deploy tool call, but the tool still executes. Every autonomous step must remain inspectable and subject to the required operational controls. What is the defect?

    const preToolUse = async (input: PreToolUseHookInput) => {
     const approved = (input.tool_input as { approved?: boolean }).approved;
     if (input.tool_name === "deploy" && !approved) {
       console.log("Denied");
       return {};
     }
     return {};
    };

The callback reads approved from tool_input, but Agent SDK callbacks cannot inspect tool arguments before execution. The team would then block unapproved deployments before tool execution based on that assumption.
Your answer is correct
The denied branch returns an empty object, so the runtime receives no permissionDecision of deny for execution. Reviewers would evaluate whether this can block unapproved deployments before tool execution before release.
The asynchronous callback cannot return permission decisions because only synchronous hooks can block tools. The team would then block unapproved deployments before tool execution based on that assumption.
The callback compares lowercase deploy, but the SDK always converts every tool name to uppercase. The selected method would be used to block unapproved deployments before tool execution.
Overall explanation
Correct option:

The denied branch returns an empty object, so the runtime receives no permissionDecision of deny for execution. Reviewers would evaluate whether this can block unapproved deployments before tool execution before release.

Returning an empty object tells the Agent SDK to allow the operation without changes. Logging Denied records an observation but supplies no enforcement decision. In this scenario, that is what allows the team to block unapproved deployments before tool execution.

The branch should return hookSpecificOutput with the PreToolUse hook event and permissionDecision set to deny. A permissionDecisionReason can tell Claude why the action was blocked. This makes the expected behavior easier to measure under production-like conditions.

That response prevents the deploy call before execution while preserving a clear trace. The ordinary empty return remains appropriate only for calls the policy allows. That makes the design easier to audit and maintain over time.

Incorrect options:

The callback reads approved from tool_input, but Agent SDK callbacks cannot inspect tool arguments before execution. The team would then block unapproved deployments before tool execution based on that assumption.

PreToolUse input includes the requested tool arguments in tool_input. Reading the approval field before execution is therefore a valid place to apply the policy. The design would still fail to block unapproved deployments before tool execution.

The application must still validate that field against trusted authorization state. Its presence in the callback is not what allows the call. The missing control would have to be added elsewhere in the design.

The callback compares lowercase deploy, but the SDK always converts every tool name to uppercase. The selected method would be used to block unapproved deployments before tool execution.

Agent SDK hooks receive the tool name used by the runtime; the SDK does not universally uppercase it. A custom tool named deploy can be compared using that registered name. Reviewers could not use this as evidence that the system will block unapproved deployments before tool execution.

A matcher mismatch could prevent a hook from firing, but the shown callback has already reached its denied branch. The return value remains the relevant defect. A separate control would still be required before the option could satisfy the requirement.

The asynchronous callback cannot return permission decisions because only synchronous hooks can block tools. The team would then block unapproved deployments before tool execution based on that assumption.

Agent SDK hook callbacks may be asynchronous and can still return enforcement decisions. The runtime waits for ordinary callback output before proceeding. This would not reliably block unapproved deployments before tool execution.

Only the special asynchronous side-effect output mode gives up the ability to block. The artifact does not use that mode. The team could not use this choice as reliable evidence for release.

References:

https://code.claude.com/docs/en/agent-sdk/hooks

https://code.claude.com/docs/en/hooks

https://code.claude.com/docs/en/agent-sdk/permissions
Domain
Agents and Workflows
Question 41Correct
A content-moderation assistant passes its overall offline score, but safety-critical false negatives remain concentrated in a small adversarial slice. The solution must keep authorization and safety controls outside untrusted model or content instructions. Which deployment plan best limits risk while the team improves the guardrails?
Deploy globally after the average score passes, then disable detailed logging so production traffic cannot influence future safety evaluation results. The application would follow this approach to apply slice-specific controls during gradual rollout.
Keep the system offline until every possible adversarial input has been enumerated and blocked by rules. This would become the basis used to apply slice-specific controls during gradual rollout.
Release to all users immediately and rely on user complaints to identify harmful output patterns afterward. The application would follow this approach to apply slice-specific controls during gradual rollout.
Your answer is correct
Use a staged rollout with safety-slice thresholds, layered screening, production monitoring, and a documented and tested rollback path. Reviewers would evaluate whether this can apply slice-specific controls during gradual rollout.
Overall explanation
Correct option:

Use a staged rollout with safety-slice thresholds, layered screening, production monitoring, and a documented and tested rollback path. Reviewers would evaluate whether this can apply slice-specific controls during gradual rollout.

Safety-slice thresholds keep the known high-risk behavior visible instead of allowing the aggregate score to mask it. Staged rollout limits how many users encounter an unresolved failure while the team measures real behavior. In this scenario, that is what allows the team to apply slice-specific controls during gradual rollout.

Layered screening addresses malicious or disallowed content at more than one point in the workflow. Production monitoring then detects regressions, new attack patterns, and differences from offline evaluation. This makes the expected behavior easier to measure under production-like conditions.

A documented and tested rollback path lets the team respond quickly when the slice breaches its quality bar. Together these controls support evidence-driven expansion rather than an all-or-nothing launch. That makes the design easier to audit and maintain over time.

Incorrect options:

Deploy globally after the average score passes, then disable detailed logging so production traffic cannot influence future safety evaluation results. The application would follow this approach to apply slice-specific controls during gradual rollout.

An aggregate score can conceal severe failures in a small safety-critical slice. Passing the average therefore does not justify ignoring the known false negatives. The design would still fail to apply slice-specific controls during gradual rollout.

Disabling detailed monitoring removes the evidence needed to detect drift and new adversarial patterns. Production observations should inform future safety evaluation rather than be excluded from it. The missing control would have to be added elsewhere in the design.

Keep the system offline until every possible adversarial input has been enumerated and blocked by rules. This would become the basis used to apply slice-specific controls during gradual rollout.

Exhaustively enumerating every adversarial input is not a realistic completion condition for a generative system. Rule-only blocking also leaves rephrased or novel attacks uncovered. Reviewers could not use this as evidence that the system will apply slice-specific controls during gradual rollout.

The team should continue targeted red teaming and guardrail improvement without claiming the input space is finite. A controlled rollout can gather evidence while bounding exposure. A separate control would still be required before the option could satisfy the requirement.

Release to all users immediately and rely on user complaints to identify harmful output patterns afterward. The application would follow this approach to apply slice-specific controls during gradual rollout.

A full immediate release exposes all users to the known safety-critical failure mode at once. User complaints are a late and incomplete detection channel for harmful outputs. This would not reliably apply slice-specific controls during gradual rollout.

Safe deployment requires proactive thresholds and observability before broad exposure. Feedback can supplement those controls, but it should not replace them. The team could not use this choice as reliable evidence for release.

References:

https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/mitigate-jailbreaks

https://platform.claude.com/docs/en/test-and-evaluate/develop-tests

https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents
Domain
Security and Safety
Question 42Correct
A regulated extraction service requires reproducible validation and controlled model upgrades. The selected approach must produce clear request, response, and operational behavior across the workflow. Which TWO practices best support that requirement?
Your selection is correct
Evaluate the candidate model version before deliberately changing the pinned production configuration for release. The design would use this reasoning to pin model versions and preserve release evidence.
Select a different model for each request according to temporary availability rather than validated behavior. Reviewers would evaluate whether this can pin model versions and preserve release evidence.
Rotate among model aliases whenever capacity changes, allowing request-time routing to replace the version validated for regulated production use. Reviewers would evaluate whether this can pin model versions and preserve release evidence.
Use a moving model alias so production upgrades occur automatically without review, evaluation, or release approval. The application would follow this approach to pin model versions and preserve release evidence.
Your selection is correct
Record the exact model identifier with each evaluation result and production release artifact. Reviewers would evaluate whether this can pin model versions and preserve release evidence.
Overall explanation
Correct options:

Evaluate the candidate model version before deliberately changing the pinned production configuration for release. The design would use this reasoning to pin model versions and preserve release evidence.

Testing the candidate against representative cases reveals behavioral changes before production configuration moves. Deliberate pin updates keep the release decision explicit and reviewable. That directly supports the need to pin model versions and preserve release evidence.

The evaluation should use the same success criteria applied to the current production model. Only an accepted result should authorize the configuration change. It gives reviewers concrete evidence instead of relying on an informal assumption.

Migration tests should cover task accuracy, edge cases, response handling, and any relevant performance requirements. The release plan must also identify the previously approved version for recovery. This also reduces ambiguity when the team investigates a regression.

Record the exact model identifier with each evaluation result and production release artifact. Reviewers would evaluate whether this can pin model versions and preserve release evidence.

Recording the exact model identifier links each test result to the snapshot that produced it. The production release artifact then proves which evaluated model was deployed. This is the mechanism the team needs to pin model versions and preserve release evidence.

That trace remains valuable when models are deprecated and a migration becomes necessary. Auditors can distinguish evidence for the old release from evidence for its replacement. The team can verify the behavior with explicit checks before release.

Runtime logs should capture the returned model identifier where available and compare it with approved configuration. A mismatch can then be investigated before it contaminates validation records. This keeps the production decision traceable when the system changes.

Incorrect options:

Use a moving model alias so production upgrades occur automatically without review, evaluation, or release approval. The application would follow this approach to pin model versions and preserve release evidence.

A moving alias can resolve to a different snapshot without the regulated service selecting that change. Automatic movement bypasses its required evaluation and approval process. The proposed assumption does not help the implementation pin model versions and preserve release evidence.

Convenience routing is useful only when the application accepts that upgrade behavior. It does not provide the deliberate configuration control required here. The gap would remain visible during testing or production operation.

Rotate among model aliases whenever capacity changes, allowing request-time routing to replace the version validated for regulated production use. Reviewers would evaluate whether this can pin model versions and preserve release evidence.

Capacity-driven rotation allows requests from one release to use different model behavior. The validated result can no longer define what production actually ran. The option leaves no dependable way to pin model versions and preserve release evidence.

Operational availability should be addressed with an approved resilience design. It must not silently replace a regulated versioning decision. For that reason, the option does not meet the scenario as written.

Select a different model for each request according to temporary availability rather than validated behavior. Reviewers would evaluate whether this can pin model versions and preserve release evidence.

Per-request model selection makes identical inputs depend on transient capacity rather than one validated configuration. Investigators could not reproduce a result without reconstructing an unstable routing decision. The design would still fail to pin model versions and preserve release evidence.

The service needs predictable version behavior for audit and comparison. Opportunistic selection conflicts with that requirement. The missing control would have to be added elsewhere in the design.

References:

https://platform.claude.com/docs/en/about-claude/models/model-ids-and-versions

https://platform.claude.com/docs/en/about-claude/models/choosing-a-model

https://platform.claude.com/docs/en/about-claude/model-deprecations
Domain
Applications and Integration
Question 43Correct
A team needs Claude to find current public sources with citations and check order eligibility against a proprietary database with company rules. The implementation must respect the documented boundary between Claude, the tool, and the host application. Which TWO implementation choices correctly match these capabilities?
Your selection is correct
Use the built-in web search tool for current public sources and its server-side citation workflow during research. The application would follow this approach to combine cited web search with private tools during release review.
Both capabilities must use Skills because tools cannot access live data or invoke application code securely. The application would follow this approach to combine cited web search with private tools.
A built-in tool can be redefined with the company's proprietary database schema and executed directly inside every client application. This would become the basis used to combine cited web search with private tools.
Your selection is correct
Use a custom client tool for proprietary order eligibility checks that the application executes locally. The application would follow this approach to combine cited web search with private tools.
A custom client tool automatically receives Anthropic-managed web search results and citations without application execution or result handling. The application would follow this approach to combine cited web search with private tools.
Overall explanation
Correct options:

Use the built-in web search tool for current public sources and its server-side citation workflow during research. The application would follow this approach to combine cited web search with private tools during release review.

The built-in web search tool gives Claude access to current public web content. Anthropic runs this server tool rather than asking the application to implement the search backend. In this scenario, that is what allows the team to combine cited web search with private tools.

Web search responses include citations to the retrieved sources. That behavior directly satisfies the public research and citation requirement. This makes the expected behavior easier to measure under production-like conditions.

Using the built-in capability avoids inventing an application-specific search contract for a general web task. The team should still configure allowed domains and usage controls when its policy requires them. That makes the design easier to audit and maintain over time.

Use a custom client tool for proprietary order eligibility checks that the application executes locally. The application would follow this approach to combine cited web search with private tools.

A custom client tool lets the application define a schema for the proprietary eligibility inputs. Claude can request the operation without receiving direct database access. The option therefore enables the implementation to combine cited web search with private tools.

The application executes the tool against its private data and company rules. It then returns only the result needed for the conversation. The resulting control can be exercised repeatedly during regression testing.

Client-side execution also lets the application enforce authentication, validation, and logging at its own boundary. Those controls remain necessary even when Claude constructs a schema-valid request. Future changes can be reviewed without losing the original reasoning.

Incorrect options:

A built-in tool can be redefined with the company's proprietary database schema and executed directly inside every client application. This would become the basis used to combine cited web search with private tools.

Built-in tools have Anthropic-defined capabilities and input contracts. An application cannot redefine one with its private database schema and turn it into a proprietary eligibility operation. The design would still fail to combine cited web search with private tools.

Application-specific behavior belongs in a custom client tool or another supported external integration. The client then controls execution against its own systems. The missing control would have to be added elsewhere in the design.

A custom client tool automatically receives Anthropic-managed web search results and citations without application execution or result handling. The application would follow this approach to combine cited web search with private tools.

A custom client tool is executed by the caller's application after Claude requests it. Anthropic does not automatically supply web results or citations through an arbitrary custom schema. Reviewers could not use this as evidence that the system will combine cited web search with private tools.

The application must validate the tool input, perform the operation, and return a tool result. Managed public web search is a separate built-in server tool. A separate control would still be required before the option could satisfy the requirement.

Both capabilities must use Skills because tools cannot access live data or invoke application code securely. The application would follow this approach to combine cited web search with private tools.

Tools are specifically intended to let Claude obtain live information or request application actions. A custom client tool can invoke private application code, while a built-in web tool can retrieve current public information. This would not reliably combine cited web search with private tools.

Skills can add reusable instructions, but the scenario asks for executable data access. Claiming that tools cannot provide it reverses the documented roles. The team could not use this choice as reliable evidence for release.

References:

https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview

https://platform.claude.com/docs/en/agents-and-tools/tool-use/web-search-tool

https://platform.claude.com/docs/en/agents-and-tools/tool-use/define-tools
Domain
Tools and MCPs
Question 44Correct
This Python function summarizes independent documents, but latency grows almost linearly with document count. The team wants a production design that can be tested, monitored, and supported without changing the stated behavior. Which change best improves throughput safely?

    async def summarize_all(client, docs):
       results = []
       for doc in docs:
           results.append(await summarize(client, doc))
       return results

Cache the first summary and return it for every document to eliminate additional network calls. The design would use this reasoning to process independent documents concurrently within safe limits.
Remove async from summarize_all and call the same network requests synchronously inside the existing loop instead. Reviewers would evaluate whether this can process independent documents concurrently within safe limits.
Launch every request simultaneously without any concurrency limit, timeout, cancellation policy, or handling for any partial service failures. Reviewers would evaluate whether this can process independent documents concurrently within safe limits.
Your answer is correct
Run independent summaries with bounded concurrency, then preserve document order when collecting completed results. The design would use this reasoning to process independent documents concurrently within safe limits.
Overall explanation
Correct option:

Run independent summaries with bounded concurrency, then preserve document order when collecting completed results. The design would use this reasoning to process independent documents concurrently within safe limits.

The summaries are independent, so a limited number can run while earlier requests are waiting on the network. A concurrency bound prevents the function from creating an uncontrolled request burst. This is the mechanism the team needs to process independent documents concurrently within safe limits.

Collecting results by original index preserves the caller-visible document order even if tasks finish differently. Timeouts and cancellation handling can be applied around each bounded task. The team can verify the behavior with explicit checks before release.

Tests should vary completion order, inject one failed request, and assert both the concurrency ceiling and output mapping. Load tests can then select a limit that respects service rate and resource constraints. This keeps the production decision traceable when the system changes.

Incorrect options:

Remove async from summarize_all and call the same network requests synchronously inside the existing loop instead. Reviewers would evaluate whether this can process independent documents concurrently within safe limits.

Changing the wrapper to synchronous execution leaves the requests serialized. Each document would still wait for the preceding network call to finish. The design would still fail to process independent documents concurrently within safe limits.

The edit can also conflict with an asynchronous SDK client or event loop. It removes concurrency syntax without addressing the latency pattern. The missing control would have to be added elsewhere in the design.

Launch every request simultaneously without any concurrency limit, timeout, cancellation policy, or handling for any partial service failures. Reviewers would evaluate whether this can process independent documents concurrently within safe limits.

Starting the entire input set at once may reduce one small run, but it creates no upper bound on open work. Large batches can exhaust connections, trigger rate limits, and amplify retry traffic. This would not reliably process independent documents concurrently within safe limits.

The option also omits timeout and partial-failure behavior that safe concurrency requires. Throughput gains do not justify an unbounded fan-out. The team could not use this choice as reliable evidence for release.

Cache the first summary and return it for every document to eliminate additional network calls. The design would use this reasoning to process independent documents concurrently within safe limits.

Reusing the first summary for unrelated documents corrupts the function result. It improves apparent latency only by skipping the requested work. The proposed assumption does not help the implementation process independent documents concurrently within safe limits.

A cache key would need to represent the actual document and relevant request configuration. One shared value cannot preserve document-specific summaries. The gap would remain visible during testing or production operation.

References:

https://platform.claude.com/docs/en/cli-sdks-libraries/sdks/python

https://platform.claude.com/docs/en/cli-sdks-libraries/overview

https://platform.claude.com/docs/en/api/rate-limits
Domain
Applications and Integration
Question 45Correct
A team is choosing between Anthropic's official SDK and direct REST calls for two services. The team must interpret the behavior correctly before changing model settings or request handling. Which TWO implementation statements are correct?
Your selection is correct
Use the official SDK for typed, idiomatic request objects and language-native response handling in code. The selected method would be used to choose correctly between SDK and REST implementations before release.
Omit the API-version header because raw REST compatibility follows the JSON body automatically. The design would use this reasoning to choose correctly between SDK and REST implementations.
Wrap REST JSON in SDK classes before sending every HTTP request. This would become the basis used to choose correctly between SDK and REST implementations.
Assume SDK and raw REST response objects are identical, including all language-specific helper methods. Reviewers would evaluate whether this can choose correctly between SDK and REST implementations.
Your selection is correct
For raw REST, send documented headers and JSON to the Messages endpoint. The team would apply the same decision when it must choose correctly between SDK and REST implementations.
Overall explanation
Correct options:

Use the official SDK for typed, idiomatic request objects and language-native response handling in code. The selected method would be used to choose correctly between SDK and REST implementations before release.

Official client SDKs provide idiomatic interfaces and type safety for their supported languages. Those interfaces reduce manual construction of request objects and response handling code. The important point is that the design can choose correctly between SDK and REST implementations.

The SDK maps language-native calls to the Messages API contract. Developers can work with the conventions of their language while still controlling each request. The implementation can record the result and compare it with the acceptance criteria.

Using an SDK does not remove the need for application validation and policy checks. It supplies a maintained integration surface rather than business correctness guarantees. The same evidence can support monitoring, rollback, and later revisions.

For raw REST, send documented headers and JSON to the Messages endpoint. The team would apply the same decision when it must choose correctly between SDK and REST implementations.

A raw REST client can call the Messages endpoint directly with a JSON request body. It must send the documented authentication, API-version, and content-type headers itself. This is the mechanism the team needs to choose correctly between SDK and REST implementations.

Direct HTTP avoids a language SDK dependency but transfers more protocol responsibility to the application. The implementation must parse responses and errors according to the API contract. The team can verify the behavior with explicit checks before release.

Both integration styles ultimately call the same service behavior. The correct choice depends on runtime constraints and how much client plumbing the team wants to own. This keeps the production decision traceable when the system changes.

Incorrect options:

Assume SDK and raw REST response objects are identical, including all language-specific helper methods. Reviewers would evaluate whether this can choose correctly between SDK and REST implementations.

SDKs expose language-specific types, helpers, and error objects that raw JSON does not contain. The underlying API fields may correspond, but the in-process objects are not universally identical. This would not reliably choose correctly between SDK and REST implementations.

Code should follow the chosen client's documented response surface. Assuming helper parity can cause runtime errors or skipped handling. The team could not use this choice as reliable evidence for release.

Omit the API-version header because raw REST compatibility follows the JSON body automatically. The design would use this reasoning to choose correctly between SDK and REST implementations.

Raw REST requests require the documented API-version header. The server does not infer the intended contract solely from the JSON body. The proposed assumption does not help the implementation choose correctly between SDK and REST implementations.

Omitting a required protocol header is an integration defect rather than a compatibility strategy. The client should construct the request exactly as the API reference specifies. The gap would remain visible during testing or production operation.

Wrap REST JSON in SDK classes before sending every HTTP request. This would become the basis used to choose correctly between SDK and REST implementations.

A direct REST integration sends JSON over HTTP and does not require SDK-specific classes. Adding them would mix two client surfaces without supplying a protocol benefit. The option leaves no dependable way to choose correctly between SDK and REST implementations.

The team should either use the SDK's normal request interface or implement the documented REST contract. An unnecessary wrapper increases coupling and confusion. For that reason, the option does not meet the scenario as written.

References:

https://platform.claude.com/docs/en/cli-sdks-libraries/overview

https://platform.claude.com/docs/en/api/messages/create

https://platform.claude.com/docs/en/cli-sdks-libraries/sdks/python
Domain
Model Selection and Optimization
Question 46Correct
A team repeatedly tells Claude Code the repository's test command, formatting rules, and architectural conventions. They want these instructions loaded for every session and shared through version control without applying them to unrelated repositories. What should they do?
Store the instructions in the user-level CLAUDE.md so every local repository receives them. The application would follow this approach to load shared repository instructions in every session.
Add the conventions as permission allow rules because permissions provide persistent coding guidance for every session. The team would then load shared repository instructions in every session based on that assumption.
Repeat the complete instruction set in the first prompt of every new session. The team would then load shared repository instructions in every session based on that assumption.
Your answer is correct
Commit a concise project-level CLAUDE.md containing the shared repository instructions. The team would apply the same decision when it must load shared repository instructions in every session.
Overall explanation
Correct option:

Commit a concise project-level CLAUDE.md containing the shared repository instructions. The team would apply the same decision when it must load shared repository instructions in every session.

A project-level CLAUDE.md is designed for persistent repository instructions that Claude Code loads into sessions. Committing it shares the same context with the team. In this scenario, that is what allows the team to load shared repository instructions in every session.

Project scope keeps the instructions attached to this repository instead of every repository on a developer's machine. That matches the stated sharing and isolation requirements. This makes the expected behavior easier to measure under production-like conditions.

The file should remain concise and contain commands, conventions, and architecture facts that developers would otherwise repeat. It guides Claude's behavior but is not a deterministic permission control. That makes the design easier to audit and maintain over time.

Incorrect options:

Store the instructions in the user-level CLAUDE.md so every local repository receives them. The application would follow this approach to load shared repository instructions in every session.

A user-level CLAUDE.md applies personal instructions across projects. That is broader than the requested repository scope. The option leaves no dependable way to load shared repository instructions in every session.

It also is not normally shared through the repository's version control. Teammates would not automatically receive the same instructions. For that reason, the option does not meet the scenario as written.

Repeat the complete instruction set in the first prompt of every new session. The team would then load shared repository instructions in every session based on that assumption.

Conversation instructions can guide one session, but the team would need to repeat them whenever a new context starts. This defeats the persistence requirement. That approach conflicts with the need to load shared repository instructions in every session.

Manual repetition also creates drift as team members copy different versions. A committed project instruction file provides one reviewable source. The implementation would still fail the relevant acceptance or safety check.

Add the conventions as permission allow rules because permissions provide persistent coding guidance for every session. The team would then load shared repository instructions in every session based on that assumption.

Permission rules decide whether tools or commands can execute. They do not serve as the normal location for repository architecture and coding conventions. The design would still fail to load shared repository instructions in every session.

Using authorization configuration for descriptive guidance applies the right concern at the wrong layer. Project instructions belong in CLAUDE.md. The missing control would have to be added elsewhere in the design.

References:

https://code.claude.com/docs/en/memory

https://code.claude.com/docs/en/claude-directory

https://code.claude.com/docs/en/permissions
Domain
Claude Code
Question 47Correct
A pull request changes a response parser to handle text, tool calls, refusals, and truncation. The selected approach must produce clear request, response, and operational behavior across the workflow. Which evidence most directly supports a safe review decision?
A monitoring plan records parser failures after release but includes no pre-merge cases for non-text content blocks. The design would use this reasoning to cover every documented response and stop path.
One screenshot shows a text response succeeding on the developer's machine after the change once. Reviewers would evaluate whether this can cover every documented response and stop path.
A reviewer says the new branch structure looks cleaner than the existing response parsing code overall. The application would follow this approach to cover every documented response and stop path.
Your answer is correct
Table-driven tests verify handling for text, tool_use, refusal, and truncated response cases with assertions. The design would use this reasoning to cover every documented response and stop path.
Overall explanation
Correct option:

Table-driven tests verify handling for text, tool_use, refusal, and truncated response cases with assertions. The design would use this reasoning to cover every documented response and stop path.

Table-driven tests make each response shape and expected handling result explicit. They directly exercise the non-text and terminal cases introduced by the parser change. That directly supports the need to cover every documented response and stop path.

The fixtures can include representative content arrays and stop reasons from the Messages contract. Assertions then show whether the parser returns text, routes tool use, handles refusal, and detects truncation correctly. It gives reviewers concrete evidence instead of relying on an informal assumption.

Running the table in continuous integration gives every reviewer the same evidence before merge. A later regression can be localized to the exact response case that changed. This also reduces ambiguity when the team investigates a regression.

Incorrect options:

A reviewer says the new branch structure looks cleaner than the existing response parsing code overall. The application would follow this approach to cover every documented response and stop path.

Code clarity helps maintainability, but a visual judgment does not establish behavior for the four response paths. The reviewer still lacks evidence that each branch produces the intended result. The proposed assumption does not help the implementation cover every documented response and stop path.

A cleaner structure can contain the same semantic defect as the old parser. Approval should be based on repeatable outcomes as well as readability. The gap would remain visible during testing or production operation.

One screenshot shows a text response succeeding on the developer's machine after the change once. Reviewers would evaluate whether this can cover every documented response and stop path.

One successful text response exercises only the simplest path and is not repeatable review evidence. It says nothing about tool blocks, refusal routing, or truncated output. The option leaves no dependable way to cover every documented response and stop path.

A screenshot also hides the exact fixture and assertion used to judge success. Another reviewer cannot reliably reproduce the observation from the pull request. For that reason, the option does not meet the scenario as written.

A monitoring plan records parser failures after release but includes no pre-merge cases for non-text content blocks. The design would use this reasoning to cover every documented response and stop path.

Production monitoring is useful after deployment, but it does not prove the change is ready to merge. The plan deliberately omits the non-text cases most likely to expose parser assumptions. The design would still fail to cover every documented response and stop path.

Waiting for live failures moves discovery to users and weakens rollback confidence. Pre-merge fixtures should complement monitoring rather than be replaced by it. The missing control would have to be added elsewhere in the design.

References:

https://platform.claude.com/docs/en/build-with-claude/handling-stop-reasons

https://platform.claude.com/docs/en/api/messages

https://platform.claude.com/docs/en/agents-and-tools/tool-use/handle-tool-calls
Domain
Applications and Integration
Question 48Correct
Two prompt revisions improve different sample cases, and reviewers disagree about which to deploy. The team wants a prompt structure that remains clear as the context grows or changes over time. What is the strongest next step?
Choose the longer prompt because additional instructions always improve model accuracy on unseen inputs. This would become the basis used to compare prompt revisions using held-out evidence.
Deploy both revisions randomly without defining a success metric or recording their prompt versions. The team would then compare prompt revisions using held-out evidence based on that assumption.
Select the revision preferred by the most senior reviewer and remove the competing test cases. This would become the basis used to compare prompt revisions using held-out evidence.
Your answer is correct
Evaluate both prompt versions on representative held-out cases using predefined quality and latency acceptance criteria before deployment. The design would use this reasoning to compare prompt revisions using held-out evidence.
Overall explanation
Correct option:

Evaluate both prompt versions on representative held-out cases using predefined quality and latency acceptance criteria before deployment. The design would use this reasoning to compare prompt revisions using held-out evidence.

Predefined criteria turn a subjective disagreement into a measurable comparison. Held-out cases reduce the chance that either revision is selected only because it overfits familiar examples. The important point is that the design can compare prompt revisions using held-out evidence.

Quality criteria should reflect the application's actual failure costs. Latency and token usage can be included when they affect the deployment objective. The implementation can record the result and compare it with the acceptance criteria.

The chosen prompt and evaluation results should be versioned together. Future model or prompt changes can then run the same regression set. The same evidence can support monitoring, rollback, and later revisions.

Incorrect options:

Choose the longer prompt because additional instructions always improve model accuracy on unseen inputs. This would become the basis used to compare prompt revisions using held-out evidence.

Prompt length is not a reliable proxy for quality. Extra instructions can conflict, add latency, or distract from the task. The proposed assumption does not help the implementation compare prompt revisions using held-out evidence.

The relevant question is whether a revision meets defined success criteria on representative inputs. Length can be measured as a cost factor, not assumed to be a benefit. The gap would remain visible during testing or production operation.

Deploy both revisions randomly without defining a success metric or recording their prompt versions. The team would then compare prompt revisions using held-out evidence based on that assumption.

Random deployment without a metric cannot determine which revision performs better. Missing version records also make outcomes difficult to reproduce. The option leaves no dependable way to compare prompt revisions using held-out evidence.

Production experiments require defined success measures and safe rollout controls. Controlled offline evaluation is the appropriate immediate step here. For that reason, the option does not meet the scenario as written.

Select the revision preferred by the most senior reviewer and remove the competing test cases. This would become the basis used to compare prompt revisions using held-out evidence.

Reviewer experience can inform criteria but should not replace task evidence. Removing contrary cases hides potential regressions. That approach conflicts with the need to compare prompt revisions using held-out evidence.

A defensible process retains challenging examples and judges both prompts consistently. The result should be reproducible by other reviewers. The implementation would still fail the relevant acceptance or safety check.

References:

https://platform.claude.com/docs/en/test-and-evaluate/develop-tests

https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview

https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices
Domain
Prompt and Context Engineering
Question 49Correct
A team's monthly Claude cost is higher than its spreadsheet forecast. The decision should be based on observable model behavior, token usage, and documented API semantics. Which investigation best validates the cost model?
Your answer is correct
Aggregate actual input, output, cache, and request usage by workload, then compare current pricing assumptions. The selected method would be used to reconcile token usage with current model pricing during release review.
Lower max_tokens globally before identifying which workload or token category caused the difference. The selected method would be used to reconcile token usage with current model pricing.
Assume the invoice is incorrect whenever generated responses are shorter than user prompts. The implementation would treat this as the rule for how to reconcile token usage with current model pricing.
Estimate all requests from the median character count and ignore response usage fields. The application would follow this approach to reconcile token usage with current model pricing.
Overall explanation
Correct option:

Aggregate actual input, output, cache, and request usage by workload, then compare current pricing assumptions. The selected method would be used to reconcile token usage with current model pricing during release review.

Usage data shows the token categories and request volumes that actually occurred. Segmenting by workload reveals whether a particular route, prompt, or output pattern drove the increase. The option therefore enables the implementation to reconcile token usage with current model pricing.

Cache reads and cache writes can have different pricing effects from ordinary input tokens. The model should represent those categories rather than collapsing every input into one rate. The resulting control can be exercised repeatedly during regression testing.

After reconciling observed usage with current pricing, the team can test targeted optimizations. This sequence separates measurement error from a real workload change. Future changes can be reviewed without losing the original reasoning.

Incorrect options:

Estimate all requests from the median character count and ignore response usage fields. The application would follow this approach to reconcile token usage with current model pricing.

Character counts are not exact token counts and the median can hide expensive tails. Ignoring response usage also omits the most direct evidence from completed calls. The proposed assumption does not help the implementation reconcile token usage with current model pricing.

A cost model should represent actual workload distributions. A rough character estimate can support early planning but not invoice reconciliation. The gap would remain visible during testing or production operation.

Lower max_tokens globally before identifying which workload or token category caused the difference. The selected method would be used to reconcile token usage with current model pricing.

A global output reduction changes product behavior before the cause is known. It may truncate valuable responses while leaving a large input or cache issue untouched. That approach conflicts with the need to reconcile token usage with current model pricing.

Optimization should follow measurement and protect quality criteria. The team needs evidence about the responsible workload and token category first. The implementation would still fail the relevant acceptance or safety check.

Assume the invoice is incorrect whenever generated responses are shorter than user prompts. The implementation would treat this as the rule for how to reconcile token usage with current model pricing.

Prompt length and response length alone do not establish an invoice error. Billing depends on token counts, feature usage, model selection, and request volume. The design would still fail to reconcile token usage with current model pricing.

Short responses can still follow large cached or uncached inputs. The usage records and published pricing assumptions are the appropriate comparison points. The missing control would have to be added elsewhere in the design.

References:

https://platform.claude.com/docs/en/build-with-claude/token-counting

https://platform.claude.com/docs/en/build-with-claude/prompt-caching

https://platform.claude.com/docs/en/manage-claude/usage-cost-api
Domain
Model Selection and Optimization
Question 50Correct
A TypeScript service streams a Claude response containing a tool call. The service attempts to parse every input_json_delta.partial_json value as a complete JSON object, so it throws an error when the first fragment ends midway through a string. The developer wants to retain streaming while producing one valid tool input. Which implementation should the developer use?

    event: content_block_delta
    data: {
     "delta": {
       "type": "input_json_delta",
       "partial_json": "{\"city\":\"San"
     }
    }

Your answer is correct
Concatenate the partial_json fragments in block order, then parse them after content_block_stop or use the SDK's incremental helpers. Reviewers would evaluate whether this can reconstruct streamed tool input before JSON parsing.
Parse each partial_json fragment independently, then merge the resulting objects after message_stop arrives. The application would follow this approach to reconstruct streamed tool input before JSON parsing.
Disable tool definitions during streaming so Claude returns the arguments as one ordinary text block. Reviewers would evaluate whether this can reconstruct streamed tool input before JSON parsing.
Ignore input_json_delta events and reconstruct the tool arguments from the final text response. The selected method would be used to reconstruct streamed tool input before JSON parsing.
Overall explanation
Correct option:

Concatenate the partial_json fragments in block order, then parse them after content_block_stop or use the SDK's incremental helpers. Reviewers would evaluate whether this can reconstruct streamed tool input before JSON parsing.

The partial_json value is explicitly a fragment, so concatenating fragments in block order preserves one logical tool input. Parsing after content_block_stop waits until the content block has finished. The option therefore enables the implementation to reconstruct streamed tool input before JSON parsing.

Claude's streaming lifecycle opens a content block, emits one or more deltas, and then closes that block. The SDK can expose parsed incremental values, while a custom event loop must accumulate the fragment strings itself. The resulting control can be exercised repeatedly during regression testing.

This approach retains streaming latency benefits without treating an incomplete string as a complete object. The completed input should still be validated against the tool schema before execution. Future changes can be reviewed without losing the original reasoning.

Incorrect options:

Parse each partial_json fragment independently, then merge the resulting objects after message_stop arrives. The application would follow this approach to reconstruct streamed tool input before JSON parsing.

A fragment is not an independent JSON object. Its boundary can occur inside a quoted string, escape sequence, or property value. The proposed assumption does not help the implementation reconstruct streamed tool input before JSON parsing.

Parsing before accumulation therefore causes the observed failure. Merging objects afterward cannot recover a fragment that never parsed successfully. The gap would remain visible during testing or production operation.

Ignore input_json_delta events and reconstruct the tool arguments from the final text response. The selected method would be used to reconstruct streamed tool input before JSON parsing.

The tool arguments belong to the tool_use content block rather than an ordinary final text response. Ignoring the input deltas discards the structured tool input. That approach conflicts with the need to reconstruct streamed tool input before JSON parsing.

Reconstructing arguments from prose can alter types or omit required fields. The application should consume the tool input delivered through the stream. The implementation would still fail the relevant acceptance or safety check.

Disable tool definitions during streaming so Claude returns the arguments as one ordinary text block. Reviewers would evaluate whether this can reconstruct streamed tool input before JSON parsing.

Streaming is compatible with tool definitions. Removing the tools changes the requested behavior instead of fixing the event consumer. The design would still fail to reconstruct streamed tool input before JSON parsing.

An ordinary text block is not a function-call contract. This also loses schema-guided tool selection and structured input validation. The missing control would have to be added elsewhere in the design.

References:

https://platform.claude.com/docs/en/build-with-claude/streaming

https://platform.claude.com/docs/en/agents-and-tools/tool-use/fine-grained-tool-streaming

https://platform.claude.com/docs/en/agents-and-tools/tool-use/handle-tool-calls
Domain
Applications and Integration
Question 51Correct
A CI job needs one non-interactive Claude Code run that emits machine-readable output and exits after the response. Any command or repository instruction must work without an unnecessary manual step. Which invocation best fits? claude -p "Summarize the repository" --output-format json
Your answer is correct
Run claude with -p and --output-format json so it prints one non-interactive result and exits. The team would then run one non-interactive machine-readable CI command based on that assumption before release.
Start claude interactively and wait for a user to issue /export after completion. This would become the basis used to run one non-interactive machine-readable CI command.
Pipe the prompt into /memory because that command runs CI and exits automatically. The team would apply the same decision when it must run one non-interactive machine-readable CI command.
Run claude without -p because interactive mode automatically emits JSON for every completed turn. The selected method would be used to run one non-interactive machine-readable CI command.
Overall explanation
Correct option:

Run claude with -p and --output-format json so it prints one non-interactive result and exits. The team would then run one non-interactive machine-readable CI command based on that assumption before release.

The -p or --print flag runs Claude Code non-interactively for a single prompt. It writes the response and exits instead of opening the normal interactive session. The important point is that the design can run one non-interactive machine-readable CI command.

The --output-format json flag selects structured JSON output for downstream processing. That makes the result easier for the CI job to validate and consume. The implementation can record the result and compare it with the acceptance criteria.

This invocation combines both requirements in one command. The job needs no user interaction after it starts. The same evidence can support monitoring, rollback, and later revisions.

Incorrect options:

Start claude interactively and wait for a user to issue /export after completion. This would become the basis used to run one non-interactive machine-readable CI command.

An interactive session waits for ongoing user input rather than performing one prompt and exiting. Requiring a person to issue /export also makes the CI job unattended only in name. Reviewers could not use this as evidence that the system will run one non-interactive machine-readable CI command.

The export command is not a substitute for print mode. Automation should select non-interactive behavior at invocation time. A separate control would still be required before the option could satisfy the requirement.

Run claude without -p because interactive mode automatically emits JSON for every completed turn. The selected method would be used to run one non-interactive machine-readable CI command.

Without -p, Claude Code starts its interactive experience by default. Interactive mode does not automatically satisfy a one-prompt-and-exit CI contract. This would not reliably run one non-interactive machine-readable CI command.

Machine-readable output must also be requested with the relevant output-format option. The option incorrectly assumes both behaviors occur automatically. The team could not use this choice as reliable evidence for release.

Pipe the prompt into /memory because that command runs CI and exits automatically. The team would apply the same decision when it must run one non-interactive machine-readable CI command.

/memory is an interactive command for inspecting or editing memory-related context. It is not the command-line switch for a single non-interactive prompt. The proposed assumption does not help the implementation run one non-interactive machine-readable CI command.

Piping text to an unrelated slash command does not establish the required JSON output contract. Print mode is the documented automation interface. The gap would remain visible during testing or production operation.

References:

https://code.claude.com/docs/en/headless

https://code.claude.com/docs/en/cli-reference

https://code.claude.com/docs/en/settings
Domain
Claude Code
Question 52Correct
A research system must compare four independent vendors and then produce one recommendation using a shared rubric. Every autonomous step must remain inspectable and subject to the required operational controls. Which execution sequence is most appropriate?
Assign vendors to one agent sequentially, then ask separate reviewers to repeat all research before synthesis. The team would then coordinate vendor research, scoring, and synthesis based on that assumption.
Store vendor names in memory and wait for later sessions to produce the recommendation. The team would apply the same decision when it must coordinate vendor research, scoring, and synthesis.
Your answer is correct
Have a supervisor delegate vendor investigations in parallel, then synthesize results against one shared rubric. The team would then coordinate vendor research, scoring, and synthesis based on that assumption during release review.
Let independent researchers produce recommendations without a coordinator comparing evidence, assumptions, and scores under the shared rubric. The team would then coordinate vendor research, scoring, and synthesis based on that assumption.
Overall explanation
Correct option:

Have a supervisor delegate vendor investigations in parallel, then synthesize results against one shared rubric. The team would then coordinate vendor research, scoring, and synthesis based on that assumption during release review.

A supervisor can assign each vendor to an isolated worker so the investigations proceed concurrently. Each worker can return a bounded evidence package instead of sharing an expanding research transcript. This is the mechanism the team needs to coordinate vendor research, scoring, and synthesis.

via - https://platform.claude.com/docs/en/managed-agents/multiagent-orchestration

The supervisor retains ownership of the common rubric and compares the returned findings consistently. That prevents four workers from applying incompatible scoring logic. The team can verify the behavior with explicit checks before release.

Final synthesis is a dependency that begins after the investigations complete. This sequence combines parallel discovery with coordinated judgment. This keeps the production decision traceable when the system changes.
via - https://www.anthropic.com/engineering/building-effective-agents

Incorrect options:

Assign vendors to one agent sequentially, then ask separate reviewers to repeat all research before synthesis. The team would then coordinate vendor research, scoring, and synthesis based on that assumption.

One agent can investigate all vendors, but the independent research tasks do not require sequential execution. Asking other reviewers to repeat every investigation adds duplicate work rather than focused verification. The design would still fail to coordinate vendor research, scoring, and synthesis.

The architecture should exploit the independence of the four vendor analyses. Synthesis should occur once the distinct evidence is available. The missing control would have to be added elsewhere in the design.

Let independent researchers produce recommendations without a coordinator comparing evidence, assumptions, and scores under the shared rubric. The team would then coordinate vendor research, scoring, and synthesis based on that assumption.

Independent recommendations preserve parallelism, but they leave the required final comparison unresolved. Different researchers may interpret rubric criteria or evidence strength differently. This would not reliably coordinate vendor research, scoring, and synthesis.

A coordinator must reconcile those assumptions and produce one accountable recommendation. Publishing four conclusions transfers the synthesis problem to the user. The team could not use this choice as reliable evidence for release.

Store vendor names in memory and wait for later sessions to produce the recommendation. The team would apply the same decision when it must coordinate vendor research, scoring, and synthesis.

Memory can persist vendor identifiers or prior findings, but it does not schedule independent work or compare results. Waiting for unspecified sessions also provides no completion dependency. The proposed assumption does not help the implementation coordinate vendor research, scoring, and synthesis.

The requirement is an orchestration problem rather than a recall problem. Delegation and synthesis must be explicit in the execution plan. The gap would remain visible during testing or production operation.

References:

https://platform.claude.com/docs/en/managed-agents/overview

https://platform.claude.com/docs/en/managed-agents/multiagent-orchestration

https://www.anthropic.com/engineering/building-effective-agents
Domain
Agents and Workflows
Question 53Correct
A support application must classify screenshots where visual layout affects the result. The selected approach must produce clear request, response, and operational behavior across the workflow. Which Messages API design best preserves the needed evidence?
Run OCR and discard the image before sending extracted text, even when layout determines the correct classification. Reviewers would evaluate whether this can preserve image evidence throughout classification.
Describe each screenshot from memory and omit the image whenever the application calls Claude. The selected method would be used to preserve image evidence throughout classification.
Upload screenshots as unrelated files, then ask Claude to infer which file belongs to each ticket. Reviewers would evaluate whether this can preserve image evidence throughout classification.
Your answer is correct
Send screenshot as an image content block with the ticket question in the same message. The design would use this reasoning to preserve image evidence throughout classification.
Overall explanation
Correct option:

Send screenshot as an image content block with the ticket question in the same message. The design would use this reasoning to preserve image evidence throughout classification.

An image content block preserves the pixels and layout that the classifier needs. Placing the ticket question in the same user message also makes the requested analysis explicit. That directly supports the need to preserve image evidence throughout classification.

The Messages API accepts image blocks from supported sources alongside text blocks. This request shape keeps the screenshot and its task together without a lossy preprocessing step. It gives reviewers concrete evidence instead of relying on an informal assumption.

Evaluation cases should include tickets whose text is identical but whose layouts imply different categories. Passing those cases would confirm that the application is using visual evidence rather than OCR alone. This also reduces ambiguity when the team investigates a regression.

Incorrect options:

Run OCR and discard the image before sending extracted text, even when layout determines the correct classification. Reviewers would evaluate whether this can preserve image evidence throughout classification.

OCR can recover visible words, but discarding the screenshot removes placement, grouping, and other layout evidence. Those visual relationships are stated to affect the ticket classification. The proposed assumption does not help the implementation preserve image evidence throughout classification.

A text-only substitute is therefore incomplete for this workload. It can produce a confident category while never seeing the feature that distinguishes the cases. The gap would remain visible during testing or production operation.

Upload screenshots as unrelated files, then ask Claude to infer which file belongs to each ticket. Reviewers would evaluate whether this can preserve image evidence throughout classification.

Uploading the screenshots without a ticket association leaves the request ambiguous about source identity. Claude would have to guess which visual evidence belongs to the question under review. The option leaves no dependable way to preserve image evidence throughout classification.

The application should encode that relationship rather than ask the model to reconstruct it. Unrelated file handling can mix evidence across support records. For that reason, the option does not meet the scenario as written.

Describe each screenshot from memory and omit the image whenever the application calls Claude. The selected method would be used to preserve image evidence throughout classification.

A description recalled by an operator is a secondary interpretation rather than the original screenshot. Important placement or state indicators can be omitted before Claude receives the request. The design would still fail to preserve image evidence throughout classification.

This design makes classification depend on human memory and inconsistent phrasing. It cannot reliably preserve the visual evidence identified in the scenario. The missing control would have to be added elsewhere in the design.

References:

https://platform.claude.com/docs/en/build-with-claude/vision

https://platform.claude.com/docs/en/build-with-claude/working-with-messages

https://platform.claude.com/docs/en/api/messages/create