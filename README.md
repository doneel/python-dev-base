# A portable python development environment

### Purpose
 * No setup required. No thinking about requirements, environment management, or toolchain.
 * Isolated environment. Add dependencies, versions, vim plugins, even non-python libraries without any fear of breaking your setup elsewhere. If you mess it up, just rebuild!
 * Customizable workflow per project. If you want to run a webserver in another tmux pane, change the formatting style or auto-start a docker-compose'd set up, those can all be automatic defaults.

### Hoes does it work?
This repo represents a generic development environment for python, entirely project agnostic. You *could* use it directly for something quick, but it won't have project dependencies installed which makes any *execution* impossible. Instead, this image is intended to be a parent image for a project-specific setup. You can find an annotated example of a project-specific image in the examples directory. 

### Features
It's a vim python development environment with sane defaults and a few strong personal preferences.
**Built in functionality**
 * 'fd' is bound to escape in all modes
 * Backups are written to `~/.vim_backups`
 * `Shift-j` and `Shift-k` for faster scrolling
 * `Ctrl-j`/`Ctrl-k`/`Ctrl-h`/`Ctrl-l` for buffer movement
 * Typical vim tags setup: `Ctrl-]` to jump to a definition for a function/class/etc.
   ** I've taken the liberty of generating tags for dependencies as well, which is much easier to do in this isolated setup. You can jump to library source code as if it were your own code. 

**Plugins**
 * `fzf` for file navigation
  ** `<Space>f` will open a fuzzy file name search with a preview window
  ** `<Space><Shift>f` will open a fuzzy full-text search
 * `deoplete` + `jedi` for autocompletion. No actions required.
 * `vim-test` for testing
  ** `Ctrl-t n` to run the nearest test when you're in a test file
  ** `Ctrl-t f` to run the whole current file of tests
  ** `Ctrl-t a` to run all tests for the whole suite/project
  ** `Ctrl-t t` re-run whatever test or set of tests you most recently ran. You *don't* still have to be in the test file.
  ** `Ctrl-t v` go back to the most recently run test
 * `semshi` for python-specific highlighting and error messages
  ** `semsehi` will display an error marker in the left gutter when there's a syntax issue.
  ** `<Space>e` will jump to the next error and display the error message to make cleanup quicker
