function tnlonly() {
  sshuttle -vr $TNL_SERVER `dns2ip $*`;
}
