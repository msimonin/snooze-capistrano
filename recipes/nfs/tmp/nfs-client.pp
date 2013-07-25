class {
    'nfs':
      nfshost  => "parapluie-23.rennes.grid5000.fr",
      shared   => "/tmp/snooze",
      local    => "/tmp/snooze",
      options  => "rw,nfsvers=3,hard,intr,async,noatime,nodev,nosuid,auto,rsize=32768,wsize=32768"
}
