# Exceptions

One row per rule this repository cannot meet yet. The reason and the revisit date
are required. The shared `standard` job reads this file.

| Rule | Reason | Revisit |
| --- | --- | --- |
| `community/.aislop/config.yml` | The aislop dependency audit is off because the transitive `http-cache-semantics` 4.2.0 carries CVE-2026-93748 with no fixed version, and the Trivy scan is the dependency gate. The divergence is documented in the file. | 2027-02-28 |
| `C7.3` | The suite is four `node:test` files and Node runs it. There is also no `bun check` type-check job: the entrypoint and the tests carry no `tsconfig.json` and rely on type stripping, so a strict project needs type-only fixes across the runtime first. Bun installs, formats and lints. | 2027-05-31 |
| `C5.1` | The required checks were 82 s at the audit snapshot, dominated by the single `node:test` tree. The measured median after the Linux-only change is recorded in the pull request. | 2027-02-28 |
