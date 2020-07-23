# bargs

[![testing](https://github.com/unfor19/bargs/workflows/testing/badge.svg)](https://github.com/unfor19/bargs/actions?query=workflow%3Atesting)

Wrap your bash script with command line arguments

Tired of doing [this - linuxcommand](http://linuxcommand.org/lc3_wss0120.php) or asking yourself [How do I parse command line arguments in Bash](https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash) easily? Great! Me too! Use this script to wrap your bash scripts with command line arguments, without bashing your head against the wall

## Requirements

- Bash v4.4+
- We're printing beautiful stuff with the `column` command so each os has its own linux-utils

### macOS

```bash
$ brew install util-linux
```

### Linux (Debian/Ubuntu)

```bash
$ sudo apt-get -y update && sudo apt-get install -y bsdmainutils
```

### Windows

Not supported (yet)

## Getting Started

1. Download the script (4 kilobytes) and put it in the same folder as your code

   ```bash
   curl -s -L bargs.link/bargs.sh --output bargs.sh
   ```

1. Creating bargs_vars - do one of the following
   - Create the file `bargs_vars`, put it in the same folder as `bargs.sh`
   - Download the existing `bargs_vars` template
     ```bash
     curl -s -L bargs.link/bargs_vars --output bargs_vars
     ```
1. Declaring arguments/variables

   - The delimiter `---` is required once at the beginning, and **twice** in the end
   - If default is empty or not defiend, the argument is required
   - You can't add comments to this file, use the description
   - Arguments values (including default) must not contain whitespace
   - Use the bargs description to set the `--help` message

   ```bash
    ---
    name=person_name
    short=n
    description=What is your name?
    default=Willy
    ---
    name=age
    short=a
    ---
    name=gender
    short=g
    ---
    name=location
    short=l
    description=insert your location
    default=chocolate-factory
    ---
    name=bargs
    description=bash example.sh -n Willy --gender male -a 99
    ---
    ---
   ```

1. Add the following line at the beginning of your application

   ```bash
   source bargs.sh "$@"
   ```

1. That's it! You can now reference to arguments that were declared in `bargs_vars`

### Usage

Using the `bargs_args` above in our application - `example.sh`

```bash
#!/bin/bash
source bargs.sh "$@"

echo -e \
"Name:~$person_name\n"\
"Age:~$age\n"\
"Gender:~$gender\n"\
"Location:~$location" | column -t -s "~"
```

#### Usage output

- Using the help flag

  ```bash
  bash example.sh -h

  Usage: bash example.sh -n Willy --gender male -a 99

        --person_name  |  -n  [Willy]              What is your name?
        --age          |  -a  [Required]
        --gender       |  -g  [Required]
        --location     |  -l  [chocolate-factory]  insert your location
  ```

- Using default values

  ```bash
  $ bash example.sh -a 99 --gender male

  Name:      Willy
  Age:       99
  Gender:    male
  Location:  chocolate-factory
  ```

- Providing all arguments

  ```bash
  $ bash example.sh -a 23 --gender male -l neverland -n meir

  Name:      meir
  Age:       23
  Gender:    male
  Location:  neverland
  ```

- Providing an empty required argument

  ```bash
  $ bash example.sh -a 99 --gender

  [ERROR] Empty argument: gender

  Usage: bash example.sh -n Willy --gender male -a 99

        --person_name  |  -n  [Willy]              What is your name?
        --age          |  -a  [Required]
        --gender       |  -g  [Required]
        --location     |  -l  [chocolate-factory]  insert your location
  ```

- Providing an unknown argument

  ```bash
  $ bash example.sh -a 99 -u meir

  [ERROR] Unknown argument: -u

  Usage: bash example.sh -n Willy --gender male -a 99

        --person_name  |  -n  [Willy]              What is your name?
        --age          |  -a  [Required]
        --gender       |  -g  [Required]
        --location     |  -l  [chocolate-factory]  insert your location
  ```

## Authors

Created and maintained by [Meir Gabay](https://github.com/unfor19)

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/unfor19/bargs/blob/master/LICENSE) file for details
