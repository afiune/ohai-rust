extern crate clap;

use clap::{App, Arg};

pub const VERSION: &str = include_str!("../VERSION");

fn main() {
    // parses the CLI options, loads the config file if present, and initializes logging
    let app = App::new("ohai").version(VERSION).args(&arguments());
    let _matches = app.get_matches();
    //configure_ohai();
    if let Err(e) = run() {
        println!("Error: {}", e);
        std::process::exit(1)
    }
}

fn run() -> Result<(), String> {
    println!("{}");
    Ok(())
}

fn arguments<'a>() -> Vec<Arg<'a, 'a>> {
    vec![
        Arg::from_usage("-c --config=[file] 'A configuration file to use'"),
        Arg::from_usage("-d --directory=[dir] 'A directory to add to the Ohai plugin search path.'"),
        Arg::from_usage("-l --log-level=[level] 'Set the log level (debug, info, warn, error, fatal)'"),
        Arg::from_usage("-L --logfile=[logfile] 'Set the log file location, defaults to STDOUT'")
    ]
}

