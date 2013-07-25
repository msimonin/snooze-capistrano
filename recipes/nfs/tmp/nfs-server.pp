class {
  'nfs::server':
    shared => "/tmp/snooze",
    uid    => "root",
    gid    => "root"
}
