# Weblink.vim

Copy to the system clipboard a link to the current file open with vim.

DISCLAIMER:

- Currently supported only MacOS (`pbcopy`)
- Currently supported only Stash directory structure

When browsing your repositories you often want to share a link to a colleague
to the specific file or line number for them to review it.

## Installation

Use your favourite plugin manager. Example with `Plug`

```
Plug `izifortune/weblink.vim`
```

## Configuration

Make sure to add the following global variables to your vim settings:

`g:weblink_host_url`
Add your your git host url including protocol and port eg: https://stash.com

`g:weblink_host_url_prefix`
Add a prefix appended after the host eg: /projects/

## Usage

The plugin add a new command available

`:WebLink ?`

Copy to the system clipboard the weblink to the file. Optional parameter of 1
will also append the line number.
