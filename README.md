# UmbracoDocs 2.0

This is a POC of using some cool new tools to run and manage the UmbracoDocs.

To run this locally run the `build-docs.ps1` file in the root repository, it will download Docfx and the Umbraco CMS source code, then build the API docs from the code and build static files for a site.

To see it locally you can run `docfx serve` after running the build script and then see it on localhost:8080

If you are doing any changes and want to update the local site you can run this `docfx build docfx.json --serve`

If you want to run a test agains't our style rules then run this command from the root `vale --glob='*.md' articles`