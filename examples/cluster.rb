cluster :example do
  
  aws_access_key_id '0WR9A355H2JG63WDHZ02'
  aws_secret_access_key 'CLhsaJKfaVnszYEshp33yv5WoccHxtnEhJob+9QT'
  
  environment :production0 do
    role :app
    role :db
  end
  
end