<img src="/docs/img/builder.jpg" align="right" height="300" width="300" />

# Kronometrix Builder

Responsible to build all Kronometrix software, from data recording, transport and analytics modules. Built, as an independent, autonomous software system, the builder is designed to maintain entire Kronometrix software stack: detect and keep up to date each software library used, compile and test the software and build the final software packages.

## Usage

```
Usage: ./builder [-acht] [-p prefix_path]
          [-b build_number] [-m module_name] 
          [-P platform] pkg version

Supported packages:
   recording
   auth, admin, stats, aggregates, mesh, mon
   mqtt, avmet, vcam

OPTIONS
  -a autonomous mode
  -c catalog check
  -P platform: x64, arm
  -b build_number: 01, 10, 102
  -m module_name: perl, openssl, curl, sysstat, scripts
  -p prefix_path: /opt/kronometrix
  -t test_mode
  -h help

  eg, builder recording 1.3.20      # build recording 1.3.20
      builder auth 1.0.0            # build analytics auth 1.0.0
      builder -P arm auth 1.0.0     # build arm analytics auth 1.0.0
      builder stats  1.0.0          # build analytics kernel stats 1.0.0
      builder mon 1.0.17            # build platform mon 1.0.17
      builder -a recording 1.8.20   # auto mode on

Notes:
   Make sure you have defined WORKSPACE_PREFIX variable before running
   builder
```


## Engines

Builder uses one or more data engines, where we have configured entire building process. Each engine is a avaiable for a compatible operating system and Kronometrix release

- engine.rec.darwin.10x
- engine.rec.freebsd.10x
- engine.rec.linux.10x
- engine.rec.solaris.10x


## Start

```
$ /opt/builder/bin/builder recording 1.8.2

#################################################################
# Build Engine                                                  #
#################################################################
# Start: Thu Apr  8 16:01:39 EEST 2021
# Target: linux x86_64
# Module: recording
# Version: 1.8.2
#################################################################
############################################################
Submodule: perl
Info: Step 1 - Extracting perl-5.32.1 ...
Info: Step 2 - Configure perl ...
Info: Step 3 - Make perl...
Info: Step 4 - Make test perl...
Info: Step 5 - Make install perl...
############################################################
Submodule: openssl
Info: Step 1 - Extracting openssl-1.1.1k ...
Info: Step 2 - Configure openssl ...
Info: Step 3 - Make openssl...
Info: Step 4 - Make install openssl...
############################################################
Submodule: expat
Info: Step 1 - Extracting expat-2.3.0 ...
Info: Step 2 - Configure expat ...
Info: Step 3 - Make expat...
Info: Step 4 - Make install expat...
############################################################
Submodule: curl
Info: Step 1 - Extracting curl-7.76.0 ...
Info: Step 2 - Configure curl ...
Info: Step 3 - Make curl...
Info: Step 4 - Make install curl...
Warning: lib directory found...
############################################################
Submodule: fio
Info: Step 1 - Extracting fio-3.26 ...
Info: Step 2 - Configure fio ...
Info: Step 3 - Make fio...
Info: Step 4 - Make install fio...
############################################################
Submodule: Net-SSLeay
Info: Step 1 - Extracting Net-SSLeay-1.90 ...
Info: Step 2 - Configure Net-SSLeay ...
Info: Step 3 - Make Net-SSLeay...
Info: Step 4 - Make install Net-SSLeay...
############################################################
Submodule: IO-Socket-SSL
Info: Step 1 - Extracting IO-Socket-SSL-2.070 ...
Info: Step 2 - Configure IO-Socket-SSL ...
Info: Step 3 - Make IO-Socket-SSL...
Info: Step 4 - Make install IO-Socket-SSL...
############################################################
Submodule: XML-Parser
Info: Step 1 - Extracting XML-Parser-2.46 ...
Info: Step 2 - Configure XML-Parser ...
Info: Step 3 - Make XML-Parser...
Info: Step 4 - Make install XML-Parser...
############################################################
Submodule: Perl CPAN
Info: Step 1 - Install Perl CPAN modules
 CPAN module: Proc::Daemon
 CPAN module: Proc::PID::File
 CPAN module: JSON::XS
 CPAN module: Data::Peek
 CPAN module: CPAN::DistnameInfo
 CPAN module: File::Tail
 CPAN module: Regexp::Common
 CPAN module: Filesys::Df
 CPAN module: Sys::Filesystem
 CPAN module: HTML::TableExtract
 CPAN module: JSON
 CPAN module: UUID::Tiny
 CPAN module: Carp::Assert
 CPAN module: Net::Domain::TLD
 CPAN module: Geography::Countries
 CPAN module: DateTime::Format::ISO8601
 CPAN module: Email::Valid
 CPAN module: Spreadsheet::XLSX
 CPAN module: Geo::IPfree
 CPAN module: Inline::MakeMaker
 CPAN module: Capture::Tiny
 CPAN module: Text::Template
 CPAN module: AnyEvent
 CPAN module: IO::Async
 CPAN module: Inline::C
 CPAN module: Date::Calc
 CPAN module: Linux::Distribution
 CPAN module: inc::Module::Install
 CPAN module: DBI
 CPAN module: IO::Interface
 CPAN module: Redis
 CPAN module: Net::DHCP::Watch
 CPAN module: Net::SNMP
 CPAN module: Mail::IMAPClient
 CPAN module: File::Stat::Bits
 CPAN module: Net::NTP
 CPAN module: Filesys::DiskUsage
 CPAN module: Net::Ping
 CPAN module: Geo::TAF
 CPAN module: JSON::MaybeXS
 CPAN module: Net::HTTP
 CPAN module: LWP
 CPAN module: LWP::Authen::OAuth
 CPAN module: LWP::Authen::OAuth2
 CPAN module: Net::OAuth2
 CPAN module: LWP::Protocol::https
 CPAN module: HTML::TreeBuilder
 CPAN module: App::SpeedTest
############################################################
Submodule: Net-Curl
Info: Step 1 - Extracting Net-Curl-0.48 ...
Info: Step 2 - Configure Net-Curl ...
Info: Step 3 - Make Net-Curl...
Info: Step 4 - Make install Net-Curl...
############################################################
Submodule: Crypt-OpenSSL-X509
Info: Step 1 - Extracting Crypt-OpenSSL-X509-1.902 ...
Info: Step 2 - Configure Crypt-OpenSSL-X509 ...
Checking if your kit is complete...
Looks good
Generating a Unix-style Makefile
Writing Makefile for Crypt::OpenSSL::X509
Writing MYMETA.yml and MYMETA.json
Info: Step 3 - Make Crypt-OpenSSL-X509...
Info: Step 4 - Make install Crypt-OpenSSL-X509...
Info: Step 5 - Install Net::SSL::ExpireDate ...
############################################################
Submodule: Linux-Info
Info: Step 1 - Extracting Linux-Info-1.5 ...
Info: Step 2 - Configure Linux-Info ...
Info: Step 3 - Make Linux-Info...
Info: Step 4 - Make install Linux-Info...
############################################################
Submodule: sysstat
Info: Step 1 - Extracting sysstat-12.5.3 ...
Info: Step 2 - Configure sysstat ...
Info: Step 3 - Make sysstat...
Info: Step 4 - Make install sysstat...
Info: Step 2 - Configure Kronometrix ...
Info: Step 3 - Make Kronometrix...
Info: Step 4 - Make install Kronometrix...
############################################################
Submodule: bin linux
Info: Step 1 - Installing setenv ...
Info: Step 2 - Installing recorders ...
############################################################
Submodule: tests linux
Info: Step 1 - Check recorders
Executing sysrec
Executing cpurec
Executing diskrec
Executing nicrec
Executing hdwrec
Info: Step 2 - Check libs
############################################################
Submodule: tar package linux
Info: Step 1 - Kronometrix tar package
############################################################
Submodule: deb package linux
Info: Step 1 - Create stage directory
Info: Step 2 - Prepare stage directory
Info: Step 3 - Cleanup stage directory
#################################################################
# SUMMARY
# Target:  linux x86_64
# Compiler: gcc (Debian 6.3.0-18+deb9u1) 6.3.0 20170516
# Built on: linux 4.9.0-15-amd64
#################################################################
# Module: recording
# Version: 1.8.2
# Build Date: Thu Apr  8 17:07:37 EEST 2021
# perl: ok
# openssl: ok
# Net-SSLeay: ok
# IO-Socket-SSL: ok
# Linux::Info: ok
# expat: ok
# fio: ok
# Perl CPAN: ok
# Perl XML::Parser: ok
# curl: ok
# sysstat: ok
# X509: ok
# webrec, svcrec: ok
# tests: ok
# tar pkg: ok
# deb pkg: ok
# FINALIZE: ok
#################################################################
# Total Build time: 1h:5m:58s
#################################################################
```

## Maintenance




