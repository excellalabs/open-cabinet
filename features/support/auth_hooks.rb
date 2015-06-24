Before('@auth') do
  @user = User.create!(email: 'test@user.com', password: 'opencabinet')
end
