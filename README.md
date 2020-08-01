# bargs

[![testing](https://github.com/unfor19/bargs/workflows/testing/badge.svg)](https://github.com/unfor19/bargs/actions?query=workflow%3Atesting)

Wrap your bash script with command line arguments

Tired of doing [this - linuxcommand](http://linuxcommand.org/lc3_wss0120.php) or asking yourself [How do I parse command line arguments in Bash](https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash) easily? Great! Me too! Use this script to wrap your bash scripts with command line arguments, without bashing your head against the wall

## Demo

- Take a look at this repository [ecs-stop-task](https://github.com/unfor19/ecs-stop-task), it demonstrates how bargs is used in a real-life situation
- Run the [example.sh](./example.sh) application with [Docker](https://docs.docker.com/engine/install/)
  ```bash
  $ docker run --rm -it unfor19/bargs:example --help
  ```

## Requirements

- Bash v4.4+
- Linux Utils - We're printing beautiful stuff with the [column](https://linux.die.net/man/1/column) command, that is included in Linux Utils

### macOS

```bash
$ brew install util-linux
```

### Linux (Debian/Ubuntu)

```bash
$ sudo apt-get -y update && sudo apt-get install -y bsdmainutils
```

### Windows

Works in Windows-Subsystem-Linux ([WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10)) using [Ubuntu 18.04](https://www.microsoft.com/en-il/p/ubuntu-1804-lts/9n9tngvndl3q?rtc=1&activetab=pivot:overviewtab)

<details><summary>More details - Expand/Collapse</summary>

Make sure you use [dos2unix](https://linux.die.net/man/1/dos2unix) on all files, see another example [here](https://github.com/unfor19/bargs/blob/master/.github/workflows/testing.yml)

```powershell
PS> choco install dos2unix
...
PS> dos2unix bargs.sh bargs_vars example.sh tests.sh
...
PS> wsl -u root -d Ubuntu-18.04 -- source example.sh
```

</details>

## Getting Started

1. Download the script (4 kilobytes) and put it in the same folder as your code

   ```bash
   curl -s -L bargs.link/bargs.sh --output bargs.sh
   ```

1. Create bargs_vars - do one of the following
   - Create the file `bargs_vars`, put it in the same folder as `bargs.sh`
   - Download the existing `bargs_vars` template
     ```bash
     curl -s -L bargs.link/bargs_vars --output bargs_vars
     ```
1. Declare arguments/variables

   - The delimiter `---` is required once at the beginning, and **twice** in the end
   - Characters which are not supported: `=`, `~`, `$`, `\`
   - If the `default` is empty or not defined, the argument is required
   - If the `default` contains whitespaces, then use double quotes - `default="Willy Wonka"`
   - You can't add comments to this file, use the description
   - Use the bargs description to set the `--help` (usage) message
   - The `options` values must separated with a whitespace

<!-- replacer_start_bargsvars -->

```
---
name=person_name
short=n
description=What is your name?
default="Willy Wonka"
---
name=age
short=a
description=How old are you?
---
name=gender
short=g
description=male or female?
options=male female
---
name=location
short=l
description=Where do you live?
default="chocolate factory"
---
name=favorite_food
short=f
default=chocolate
options=chocolate pizza
description=chocolate or pizza?
---
name=secret
short=s
default=!@#%^&*?/.,[]{}+-|
description=special characters
---
name=language
short=lang
default=
description=default value can be a variable
---
name=bargs
description=bash example.sh -n Willy --gender male -a 99
default=irrelevant
---
---
```

<!-- replacer_end_bargsvars -->

4. Make sure that `bargs.sh` and `bargs_vars` are in the same folder

1. Add **one** of the following lines at the beginning of your application (see Usage below)

   - `bargs.sh` is in the root folder of your project (just like in this repo)
     ```bash
     source "${PWD}"/"$(dirname ${BASH_SOURCE[0]})"/bargs.sh "$@"
     ```
   - `bargs.sh` is in a subfolder, for example `tools`
     ```bash
     source "${PWD}"/"$(dirname ${BASH_SOURCE[0]})"/tools/bargs.sh "$@"
     ```

1. That's it! You can now reference to arguments that were declared in `bargs_vars`

### Usage

Using the `bargs_args` above in our application - `example.sh`

```bash
#!/bin/bash
source "${PWD}"/"$(dirname ${BASH_SOURCE[0]})"/bargs.sh "$@"

echo -e \
"Name:~$person_name\n"\
"Age:~$age\n"\
"Gender:~$gender\n"\
"Location:~$location\n"\
"Favorite food:~$favorite_food\n"\
"Secret:~$secret\n"\
"OS Language:~$language\n"\
"Uppercased var names:~$PERSON_NAME, $AGE years old, from $LOCATION" | column -t -s "~"
```

#### Usage output

<details><summary>
Results after running <a href="https://github.com/unfor19/bargs/blob/master/tests.sh">tests.sh</a> - Expand/Collapse

</summary>

<!-- replacer_start_usage -->

```
-------------------------------------------------------
[LOG] Help Menu - Should pass
[LOG] Executing: source example.sh -h
[LOG] Output: 


Usage: bash example.sh -n Willy --gender male -a 99

	--person_name    |  -n     [Willy Wonka]         What is your name?
	--age            |  -a     [Required]            How old are you?
	--gender         |  -g     [Required]            male or female?
	--location       |  -l     [chocolate factory]   Where do you live?
	--favorite_food  |  -f     [chocolate]           chocolate or pizza?
	--secret         |  -s     [!@#%^&*?/.,[]{}+-|]  special characters
	--language       |  -lang  [C.UTF-8]             default value can be a variable

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] Default Values - Should pass
[LOG] Executing: source example.sh -a 99 --gender male
[LOG] Output: 

Name:                  Willy Wonka
Age:                   99
Gender:                male
Location:              chocolate factory
Favorite food:         chocolate
Secret:                !@#%^&*?/.,[]{}+-|
OS Language:           C.UTF-8
Uppercased var names:  Willy Wonka, 99 years old, from chocolate factory

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] New Values - Should pass
[LOG] Executing: source example.sh -a 23 --gender male -l neverland -n meir
[LOG] Output: 

Name:                  meir
Age:                   23
Gender:                male
Location:              neverland
Favorite food:         chocolate
Secret:                !@#%^&*?/.,[]{}+-|
OS Language:           C.UTF-8
Uppercased var names:  meir, 23 years old, from neverland

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] Valid Options - Should pass
[LOG] Executing: source example.sh -a 23 --gender male -l neverland -n meir -f pizza
[LOG] Output: 

Name:                  meir
Age:                   23
Gender:                male
Location:              neverland
Favorite food:         pizza
Secret:                !@#%^&*?/.,[]{}+-|
OS Language:           C.UTF-8
Uppercased var names:  meir, 23 years old, from neverland

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] Special Characters - Should pass
[LOG] Executing: source example.sh -a 99 --gender male -s MxTZf+6KHaAQltJWipe1oVRy
[LOG] Output: 

Name:                  Willy Wonka
Age:                   99
Gender:                male
Location:              chocolate factory
Favorite food:         chocolate
Secret:                MxTZf+6KHaAQltJWipe1oVRy
OS Language:           C.UTF-8
Uppercased var names:  Willy Wonka, 99 years old, from chocolate factory

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] Empty Argument - Should fail
[LOG] Executing: source example.sh -a 99 --gender
[LOG] Output: 

[ERROR] Empty argument: gender

Usage: bash example.sh -n Willy --gender male -a 99

	--person_name    |  -n     [Willy Wonka]         What is your name?
	--age            |  -a     [Required]            How old are you?
	--gender         |  -g     [Required]            male or female?
	--location       |  -l     [chocolate factory]   Where do you live?
	--favorite_food  |  -f     [chocolate]           chocolate or pizza?
	--secret         |  -s     [!@#%^&*?/.,[]{}+-|]  special characters
	--language       |  -lang  [C.UTF-8]             default value can be a variable

[LOG] Test failed as expected
-------------------------------------------------------
[LOG] Unknown Argument - Should fail
[LOG] Executing: source example.sh -a 99 -u meir
[LOG] Output: 

[ERROR] Unknown argument: -u

Usage: bash example.sh -n Willy --gender male -a 99

	--person_name    |  -n     [Willy Wonka]         What is your name?
	--age            |  -a     [Required]            How old are you?
	--gender         |  -g     [Required]            male or female?
	--location       |  -l     [chocolate factory]   Where do you live?
	--favorite_food  |  -f     [chocolate]           chocolate or pizza?
	--secret         |  -s     [!@#%^&*?/.,[]{}+-|]  special characters
	--language       |  -lang  [C.UTF-8]             default value can be a variable

[LOG] Test failed as expected
-------------------------------------------------------
[LOG] Invalid Options - Should fail
[LOG] Executing: source example.sh -a 23 --gender male -l neverland -n meir -f notgood
[LOG] Output: 

[ERROR] Invalid value for argument: favorite_food

Usage: bash example.sh -n Willy --gender male -a 99

	--person_name    |  -n     [Willy Wonka]         What is your name?
	--age            |  -a     [Required]            How old are you?
	--gender         |  -g     [Required]            male or female?
	--location       |  -l     [chocolate factory]   Where do you live?
	--favorite_food  |  -f     [chocolate]           chocolate or pizza?
	--secret         |  -s     [!@#%^&*?/.,[]{}+-|]  special characters
	--language       |  -lang  [C.UTF-8]             default value can be a variable

[LOG] Test failed as expected
-------------------------------------------------------
[LOG] Missing bargs_vars - Should fail
[LOG] Executing: source example.sh -h
[LOG] Output: 

[ERROR] Make sure bargs_vars is in the same folder as bargs.sh

[LOG] Test failed as expected
```

<!-- replacer_end_usage -->

</details>

## Package your application

### Docker

You can use [Docker](https://www.docker.com/why-docker) to package your Bash script as a Docker image, see the following example

1. Clone this repository

1. Build the image, see [Dockerfile.example](./Dockerfile.example), tag it `bargs:example`

   ```bash
   $ docker build -f Dockerfile.example -t bargs:example .
   ```

1. Run a container that is based on the image above :point_up:
   ```bash
   $ docker run --rm -it bargs:example -a 23 -g male
   ```

## Contributing

Report issues/questions/feature requests on the [Issues](https://github.com/unfor19/bargs/issues) section.

Pull requests are welcome! These are the steps:

1. Fork this repo
1. Create your feature branch from master (`git checkout -b my-new-feature`)
1. Add the code of your new feature
1. Run tests on your code, feel free to add more tests
   ```bash
   $ bash tests.sh
   ... # All good? Move on to the next step
   ```
1. Commit your remarkable changes (`git commit -am 'Added new feature'`)
1. Push to the branch (`git push --set-up-stream origin my-new-feature`)
1. Create a new Pull Request and provide details about your changes

## Authors

Created and maintained by [Meir Gabay](https://github.com/unfor19)

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/unfor19/bargs/blob/master/LICENSE) file for details
