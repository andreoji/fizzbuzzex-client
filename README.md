# Fizzbuzzex API Client

## Prerequisites

You will have to have a running Fizzbuzzex server and have obtained an oauth2 app's `client_id` and `client_secret` to use Fizzbuzzex-client.

## Installation

Clone the Fizzbuzzex API client repo.

### Bundler

```sh
bundle install
```

## Description

This app fullfils the requirement to consume the Fizzbuzzex API. It is written in Ruby and primarily uses the Thor gem.
It has two modes of operation depending on the command line arguments passed.

### Fizzbuzz

In this mode the app will recursively call the next page of API numbers ad infinitum, until the last page of numbers has been reached.
For each page of numbers it prints first number, last number and the next page pointer.

Running from first page when page size is 15:

```ruby
ruby lib/cli.rb fizzbuzz 'http://localhost:4000' 'api/v1/favourites' 'http://localhost:4000/oauth/token' --number=1 --size=15 --client_id=ac30330db052feb6cc9122f8f1f1bf5c0d9b1b6c6b2ede9262e50da3b55d3a92 --client_secret=ced16be7bb68a5e10779af5dc68cb100dc630c6a38c19fac9eb055289caccb06 --name=johnl --password=j123456l
```

Output when page number is 1:

```ruby
{:fizzbuzz=>"1", :number=>1, :state=>true}
{:fizzbuzz=>"fizzbuzz", :number=>15, :state=>true}
/api/v1/favourites?page[number]=2&page[size]=15
{:fizzbuzz=>"16", :number=>16, :state=>false}
{:fizzbuzz=>"fizzbuzz", :number=>30, :state=>false}
/api/v1/favourites?page[number]=3&page[size]=15
{:fizzbuzz=>"31", :number=>31, :state=>false}
{:fizzbuzz=>"fizzbuzz", :number=>45, :state=>false}
/api/v1/favourites?page[number]=4&page[size]=15
{:fizzbuzz=>"46", :number=>46, :state=>false}
{:fizzbuzz=>"fizzbuzz", :number=>60, :state=>false}
/api/v1/favourites?page[number]=5&page[size]=15
{:fizzbuzz=>"61", :number=>61, :state=>false}
{:fizzbuzz=>"fizzbuzz", :number=>75, :state=>false}
/api/v1/favourites?page[number]=6&page[size]=15
{:fizzbuzz=>"76", :number=>76, :state=>false}
{:fizzbuzz=>"fizzbuzz", :number=>90, :state=>false}
/api/v1/favourites?page[number]=7&page[size]=15
{:fizzbuzz=>"91", :number=>91, :state=>false}
{:fizzbuzz=>"fizzbuzz", :number=>105, :state=>false}
...
```

Running from second last page when page size is 15:

```ruby
ruby lib/cli.rb fizzbuzz 'http://localhost:4000' 'api/v1/favourites' 'http://localhost:4000/oauth/token' --number=6666666666 --size=15 --client_id=ac30330db052feb6cc9122f8f1f1bf5c0d9b1b6c6b2ede9262e50da3b55d3a92 --client_secret=ced16be7bb68a5e10779af5dc68cb100dc630c6a38c19fac9eb055289caccb06 --name=johnl --password=j123456l
```

Output when page number is 6666666666 (the second last page for page size of 15):

```ruby
{:fizzbuzz=>"99999999976", :number=>99999999976, :state=>false}
{:fizzbuzz=>"fizzbuzz", :number=>99999999990, :state=>false}
/api/v1/favourites?page[number]=6666666667&page[size]=15
{:fizzbuzz=>"99999999991", :number=>99999999991, :state=>false}
{:fizzbuzz=>"buzz", :number=>100000000000, :state=>false}
```

## Hypermedia client

The notion behind this app is to act as a hympermedia client of Fizzbuzzex API.
It merely follows links, until it has nothing else to do, or it is stopped with:

```sh
ctrl-c
```

### Favourite

This mode allows the favouriting / unfavouriting of a number.

To favourite 15:

```ruby
ruby lib/cli.rb favourite 'http://localhost:4000' 'api/v1/favourites' 'http://localhost:4000/oauth/token' --number=15 --fizzbuzz=fizzbuzz --state=true --client_id=ac30330db052feb6cc9122f8f1f1bf5c0d9b1b6c6b2ede9262e50da3b55d3a92 --client_secret=ced16be7bb68a5e10779af5dc68cb100dc630c6a38c19fac9eb055289caccb06 --name=johnl --password=j123456l
```

Response:

```ruby
{:status_code=>201, :data=>{:attributes=>{:fizzbuzz=>"fizzbuzz", :number=>15, :state=>true}, :id=>"2", :type=>"favourite"}}
```

To unfavourite 15:

```ruby
ruby lib/cli.rb favourite 'http://localhost:4000' 'api/v1/favourites' 'http://localhost:4000/oauth/token' --number=15 --fizzbuzz=fizzbuzz --state=false --client_id=ac30330db052feb6cc9122f8f1f1bf5c0d9b1b6c6b2ede9262e50da3b55d3a92 --client_secret=ced16be7bb68a5e10779af5dc68cb100dc630c6a38c19fac9eb055289caccb06 --name=johnl --password=j123456l
```

Response:

```ruby
{:status_code=>201, :data=>{:attributes=>{:fizzbuzz=>"fizzbuzz", :number=>15, :state=>false}, :id=>"2", :type=>"favourite"}}
```
