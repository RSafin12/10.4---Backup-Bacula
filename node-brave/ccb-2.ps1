Director {                            # define myself
  Name = brave-dir
  DIRport = 9101                # where we listen for UA connections
  QueryFile = "/etc/bacula/scripts/query.sql"
  WorkingDirectory = "/var/lib/bacula"
  PidDirectory = "/run/bacula"
  Maximum Concurrent Jobs = 20
  Password = "0pJCO_jW8SYGeB5FLgpImlONjmoYJS0Ct"         # Console password
  Messages = Standard
  DirAddress = 127.0.0.1
}

JobDefs {
  Name = "DefaultJob"
  Type = Backup
  Level = Full
  Client = brave-fd
  FileSet = "Full-Set"
  Schedule = "WeeklyCycle"
  Storage = brave-sd
  Messages = Standard
  Pool = LocalPool
  SpoolAttributes = yes
  Priority = 10
  Write Bootstrap = "/var/lib/bacula/%c.bsr"
} 

Job {
  Name = "System"
  JobDefs = "DefaultJob"
  Enabled = yes
  Level = Full
  FileSet = "System"
  Schedule = "WeeklyCycle"
  Priority = 11
  Storage = brave-sd
  Pool = LocalPool
}

FileSet {
  Name = "System"
  Include {
    Options {
      signature = MD5
    }
    File = "/etc/test"
  }
}

Schedule {
  Name = "WeeklyCycle"
  Run = Full 1st sun at 23:05
  # Run = Differential 2nd-5th sun at 23:05
  # Run = Incremental mon-sat at 23:05
}

Client {
  Name = brave-fd
  Address = localhost
  FDPort = 9102
  Catalog = MyCatalog
  Password = "HeEjNzWZaSUHE9q2PR2yl4i41yR1RcOiL"          # password for FileDaemon
  File Retention = 60 days            # 60 days
  Job Retention = 6 months            # six months
  AutoPrune = yes                     # Prune expired Jobs/Files
}


Autochanger {
  Name = node2-sd
# Do not use "localhost" here
  Address = localhost                # N.B. Use a fully qualified name here
  SDPort = 9103
  Password = "JVhZQ-8Z0gCxc0fU7VNNTYzLRyFwiL58E"          # password for StorageDaemon
  Device = local-device
  Media Type = File1
  Maximum Concurrent Jobs = 10        # run up to 10 jobs a the same time
  Autochanger = node2-sd                 # point to ourself
}

# Definition of a second file Virtual Autochanger device
#   Possibly pointing to a different disk drive
Autochanger {
  Name = brave-sd2
# Do not use "localhost" here
  Address = localhost                # N.B. Use a fully qualified name here
  SDPort = 9103
  Password = "JVhZQ-8Z0gCxc0fU7VNNTYzLRyFwiL58E"        # password for StorageDaemon
  Device = remote-device
  Media Type = File1
  Autochanger = node2-sd                 # point to ourself
  Maximum Concurrent Jobs = 10        # run up to 10 jobs a the same time
}

Pool {
  Name = LocalPool
  Pool Type = Backup
  Recycle = yes                       # Bacula can automatically recycle Volumes
  AutoPrune = yes                     # Prune expired volumes
  Volume Retention = 365 days         # one year
  Maximum Volume Bytes = 50G          # Limit Volume size to something reasonable
  Maximum Volumes = 100               # Limit number of Volumes in Pool
  Label Format = "Vol-"               # Auto label
}


Console {
  Name = brave-mon
  Password = "jS87Jz2_3zI7a9A9-0qlsM73mZZ7NVvG8"
  CommandACL = status, .status
}


# Reasonable message delivery -- send most everything to email address
#  and to the console
Messages {
  Name = Standard
}

Catalog {
  Name = MyCatalog
  dbname = "bacula"; DB Address = "localhost"; dbuser = "bacula"; dbpassword = "pass9"
}