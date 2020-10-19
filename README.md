# Weblink.vim

Copy to the clipboard a web link to your git host for current open file in vim.
Especially useful when sharing code and discussing with your team members.

DISCLAIMER:

- Currently supported only MacOS (`pbcopy`)
- Currently supported only Github and Stash directory structure

When browsing your repositories you often want to share a link to a colleague
to the specific file or line number for them to review it.

## Installation

Use your favourite plugin manager. Example with `Plug`

```
Plug 'izifortune/weblink.vim'
```

## Configuration

Ensure that you are in the root folder of your project when executing the command

## Usage

The plugin makes new commands available

`:WebLink ?`

Copy to the system clipboard the weblink to the file.
The optional parameter 1 will append the line number.

`:WebLinkBranch ?`

Copy to the system clipboard the weblink to the file including the branch.
The optional parameter 1 will append the line number.
