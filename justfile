# Generate all local doc bundles for AI agents (uses docpup, see docpup.config.yaml)
docs:
    pnpm install
    node -e "import('docpup').then(m => m.generateDocs({ yes: true }))"
