# of-store

## Store your OmniFocus projects as SQLite

of-store is a tiny little binary to export data from your OmniFocus setup for use in other applications. It's particularly handy if you want to track what you've completed in the last week, or month, or year - the longer it runs for, the more data it'll collect.

## Installation

Download and build in XCode. The result will be a binary file you can run in terminal as any other binary file.

## Usage

`of-store` will record completed projects and tasks in OmniFocus. Of note, it will **exclude** any projects or tasks in a folder named "Recurring Tasks" or "Template". These are set by `+[JRFolder forbiddenNames]`, and you can change these to suit you.

Once of-store has run it will attempt to log its activity. I do this using a custom application, and the code is contained withing `JRLog`. You may want to change this to suit your needs.