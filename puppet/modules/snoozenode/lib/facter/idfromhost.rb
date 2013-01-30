Facter.add('idfromhost') do
  setcode do
    #string here
    Facter.value(:ipaddress).split('.')[2] + Facter.value(:ipaddress).split('.')[3]
  end
end
