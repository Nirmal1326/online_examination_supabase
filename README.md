# online_examination_supabase

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.
```
$ flutter pub get
```
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Query for creating a table
use supabase cloud backend for this project. Auth is default feature in supabase. Question upload and fetch are used in this project.
create the table for multiple subjects using these query in supabase sql table editor section.
```
CREATE TABLE python (
    id SERIAL PRIMARY KEY,
    question_title TEXT,
    option_1 TEXT,
    option_2 TEXT,
    option_3 TEXT,
    option_4 TEXT,
    answer int
);
```
```
CREATE TABLE javascript (
    id SERIAL PRIMARY KEY,
    question_title TEXT,
    option_1 TEXT,
    option_2 TEXT,
    option_3 TEXT,
    option_4 TEXT,
    answer int
);
```
```
CREATE TABLE java (
    id SERIAL PRIMARY KEY,
    question_title TEXT,
    option_1 TEXT,
    option_2 TEXT,
    option_3 TEXT,
    option_4 TEXT,
    answer int
);
```
```
CREATE TABLE cpp (
    id SERIAL PRIMARY KEY,
    question_title TEXT,
    option_1 TEXT,
    option_2 TEXT,
    option_3 TEXT,
    option_4 TEXT,
    answer int
);
```
```
CREATE TABLE answer (
    id SERIAL PRIMARY KEY,
    subject TEXT,
    score INTEGER
);
```