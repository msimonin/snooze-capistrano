Facter.add('myid') do
	setcode do
		Facter.value(:ipaddress).split('.')[3]
	end
end
