# Post-Processing Scripts

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `post_process`.  
[Type](option_type#list-types): `Text list`.  
[CLI Example](cli_mode#setting-overrides): `--post-process=value`.  
Here you can set up post-processing scripts that will be executed after slicing.  
This allows you to modify the G-code output or perform additional tasks.

Check the script's documentation for dependencies, available parameters and usage instructions.

Example Python script:

```pwsh
"C:\Your\Path\To\Python\python.exe" "C:\Your\Path\To\Script\pythonScript.py" -parameterToScript 1994;
```
