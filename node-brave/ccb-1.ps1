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

# Backuping Job
Job {
  Name = "DefaultBackup"
  JobDefs = "FullBackup"
}


## Restoring job
# Job {
#  Name = "RestoreFiles"
#  Type = Restore
#  Client=brave-fd
#  Storage = File1
#  FileSet="Full Set"
#  Pool = File
#  Messages = Standard
#  Where = /nonexistant/path/to/file/archive/dir/bacula-restores
# }

# local node brave's jobs def-n
JobDefs {
  Name = "FullBackup"
  Type = Backup
  Level = Full
  Client = brave-fd
  FileSet = "Full-Set"
  Schedule = "WeeklyCycle"
  Storage = brave-stor
  Messages = Standard
  Pool = brave-pool
  SpoolAttributes = yes
  Priority = 10
  Write Bootstrap = "/var/lib/bacula/%c.bsr"
} 

# JobDefs {
#   Name = "Incremental"
#   Type = Backup
#   Level = Incremental
#   Client = brave-fd
#   FileSet = "Full Set"
#   Schedule = "WeeklyCycle"
#   Storage = brave-stor
#   Messages = Standard
#   Pool = File
#   SpoolAttributes = yes
#   Priority = 10
#   Write Bootstrap = "/var/lib/bacula/%c.bsr"
# } 

Schedule {
  Name = "WeeklyCycle"
  Run = Full 1st sun at 23:05
  Run = Differential  sat at 23:05
  Run = Incremental mon-fri at 23:05
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

# Client {
#   Name = strong-fd
#   Address = 172.16.16.15
#   FDPort = 9102
#   Catalog = MyCatalog
#   Password = "HeEjNzWZaSUHE9q2PR2yl4i41yR1RcOiL"          # password for FileDaemon
#   File Retention = 60 days            # 60 days
#   Job Retention = 6 months            # six months
#   AutoPrune = yes                     # Prune expired Jobs/Files
# }


# here should be Pool section
# Storage for local node "Brave"
Storage {
    Name = brave-stor
    Address = localhost
    Device = localstorage                
    SDPort = 9103
    Password = "1" 
    Media Type = File1
 }

# Storage for remote node "Strong"
# Storage {
#    Name = strong-stor
#    Address = localhost                
#    SDPort = 9103
#    Password = "1" 
#    Device = secondstorage
#    Media Type = File1
# }


Pool {
    Name = brave-pool
    Pool Type = Backup
    Recycle = yes                      
    AutoPrune = yes                     
    Volume Retention = 1 month         
    Maximum Volume Jobs = 5
    Maximum Volumes = 32
    Storage = brave-stor
    Label Format = "volume-" 
}

# Pool {
#     Name = strong-pool
#     Pool Type = Backup
#     Recycle = yes                      
#     AutoPrune = yes                     
#     Volume Retention = 1 month         
#     Maximum Volume Jobs = 5
#     Maximum Volumes = 32
#     Storage = strong-stor
#     Label Format = "volume-" 
# }

FileSet {
  Name = "Full-Set"
  Include {
    Options {
      signature = MD5
    }
    File = /etc/default
  }
  Exclude {
    File = /var/lib/bacula
    File = /nonexistant/path/to/file/archive/dir
    File = /proc
    File = /tmp
    File = /sys
    File = /.journal
    File = /.fsck
  }
}


Messages {
  Name = Standard
}

Console {
  Name = brave-mon
  Password = "jS87Jz2_3zI7a9A9-0qlsM73mZZ7NVvG8"
  CommandACL = status, .status
}

Catalog {
  Name = MyCatalog
  dbname = "bacula"; DB Address = "localhost"; dbuser = "bacula"; dbpassword = "pass9"
}


