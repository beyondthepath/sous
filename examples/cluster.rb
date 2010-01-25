cluster :example do

  aws_credentials 'examples/aws.yml'
  image_id 'ami-bb709dd2'
  
  environment :production do
    role :app
    role :db
  end
  
end