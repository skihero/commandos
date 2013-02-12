# Get the list of machines and their notes using the API
# the cost reported here does not include the addons of a server sometime
account_service = SoftLayer::Service.new("SoftLayer_Account")
machines = account_service.object_mask({"hardware" => ["id", "hostname","notes", "cost"]}).getHardware

machines.each do |machine|
    id = machine["id"]
    # get the cost of each machine here.  
    # Using the SoftLayer_Hardware_Server API 
    # This reports the cost as found in the invoice

    hardware_service = SoftLayer::Service.new("SoftLayer_Hardware_Server", "#{id}")
    cost = hardware_service.object_with_id("#{id}").getCost()
    if cost.is_a? Numeric 
	puts "#{id}|#{machine["hostname"]}|#{cost}|#{machine["notes"]}"
    else 
   	fail ('miserably')
    end 
	
end

