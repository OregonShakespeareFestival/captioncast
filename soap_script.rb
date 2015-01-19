#!/usr/bin/env ruby

require 'rubyntlm'
require 'savon'
require 'nokogiri'
require 'pp'

client = Savon.client(wsdl: 'http://tessgatestaging.osfashland.org/tessiturawebapi/tessitura.asmx?WSDL')

puts client.operations
response = client.call(:get_new_session_key_ex, message: { sIP: '', iBusinessUnit: 1 } )

PP.pp(response.http.raw_body, $>, 40)
