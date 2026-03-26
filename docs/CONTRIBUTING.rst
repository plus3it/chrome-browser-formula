.. _contributing:

How to contribute
===============



* Please open an issue to identify "missing" deployment contexts or broken automation or documentation:
    * If the problem is with documentation, ensure the issue's subject starts with ``[DOCUMENTATION]``
    * If the problem is with missing functionality, ensure the issue's subject starts with ``[ENHANCEMENT]``
    * If the problem is with broken functionality, ensure the issue's subject starts with ``[BUG]``
* Please open pull requests - referencing the previously-opened issue - when ready to provide automation for new contexts.

Submitting Changes
===============

Please send a GitHub Pull Request with a clear list of what changes are being offered (read more about `pull requests <http://help.github.com/pull-requests/>`_).

Please ensure that the commits bundled in the PR are performed with clear and concise commit messages. One-line messages are fine for small changes, but bigger changes should look like this:

.. code-block:: bash

    $ git commit -m "A brief summary of the commit
    >
    > A paragraph describing what changed and its impact."

Also: even if the PR doesn't otherwise include documentation-updates, ensure that the project's documentation adequately up to date. Run `make docs/generate` in the project-root. Typically, this will only update the top-level README.

Note: Depending how old your branch is, it may also be necessary to run `make terraform-docs/install` before running `make docs/generate`. If running `make docs/generate` doesn't result in `git` seeing an updated README, update your terraform-docs module.
