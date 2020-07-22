# bargs

Wrap your bash script with command line arguments

Tired of doing [this - linuxcommand](http://linuxcommand.org/lc3_wss0120.php) or asking yourself [How do I parse command line arguments in Bash](https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash) easily? Great! Me too! Use this script to wrap your bash scripts with command line arguments, without bashing your head against the wall

## Requirements

We're printing beautiful stuff with the `column` command

### macOS

```bash
$ brew install util-linux
```

### Linux (Debian/Ubuntu)

```bash
$ sudo apt-get -y update && sudo apt-get install -y bsdmainutils
```

### Windows

No idea, need to test it

## Getting Started

1. Download the script (4 kilobytes) and put it in the same folder as your code

   ```bash
   curl https://raw.githubusercontent.com/unfor19/bargs/master/bargs.sh --output bargs.sh
   ```

1. Create the file `bargs_vars`, put it in the same folder as `bargs.sh`

   - The delimiter `---` is required once at the beginning, and **twice** in the end
   - If default is empty or not defiend, the argument is required
   - You can't add comments to this file, use the description
   - Don't add quotes (or double quotes) in the description
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

1. That's it! You can now reference to arguments that were declared in `bargs_vars`, see [example.sh](https://github.com/unfor19/bargs/blob/master/example.sh)

   <details><summary>
   Examples - Expand/Collapse
   </summary>

   - ```bash
      $ bash example.sh -n Willy --gender male -a 99
      Name:      Willy
      Age:       99
      Gender:    male
      Location:  chocolate-factory
     ```

   - ```bash
      $ bash example.sh -h

      Usage: bash example.sh -n Willy --gender male -a 99
      --person_name  |  -n  [Willy]              What is your name?
      --age          |  -a  [Required]
      --gender       |  -g  [Required]
      --location     |  -l  [chocolate-factory]  insert your location
     ```

   - ```bash
      $ bash example.sh -n Meir --gender male
      [ERROR] Required argument: age

      Usage: bash example.sh -n Willy --gender male -a 99

      --person_name  |  -n  [Willy]              What is your name?
      --age          |  -a  [Required]
      --gender       |  -g  [Required]
      --location     |  -l  [chocolate-factory]  insert your location
     ```

   </details>

## Authors

Created and maintained by [Meir Gabay](https://github.com/unfor19)

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/unfor19/bargs/blob/master/LICENSE) file for details
