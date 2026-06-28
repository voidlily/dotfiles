# "rass ts" is called by eglot by default, but "ts" isn't provided in rass, so
# let's provide one
def servers():
    return [
        ["oxfmt", "--lsp"],
        ["oxlint", "--lsp"],
        ["typescript-language-server", "--stdio"],
    ]
