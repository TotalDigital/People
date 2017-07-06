domains = [] # Add your whitelisted domains here
branch = Branch.find_or_create_by(name: '') # Add branch name here

domains.each do |domain_name|
  Domain.create(name: domain_name, branch: branch)
end
