cluster :example do
  
  aws_credentials nil # TODO: set something
  slicehost_credentials nil # TODO: set something
  
  environment :production0 do
    provider :ec2
    role :app
    role :db
  end
  
  environment :production1 do
    provider :slicehost
  end
  
end