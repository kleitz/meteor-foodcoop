# Accounts.onCreateUser (options, user) ->
#
#   if options.profile.createdAt?
#     user.createdAt = options.profile.createdAt
#     delete options.profile.createdAt
#   # We still want the default hook's 'profile' behavior.
#   if options.profile
#     user.profile = options.profile
#   user
#
# # ---
# # generated by js2coffee 2.1.0
#
#
# Meteor.startup ->
#   if Meteor.settings.import
#     usersArray = EJSON.parse Assets.getText "old-users.json"
#     productsArray = EJSON.parse Assets.getText "old-products.json"
#
#     if Meteor.users.find().count() < 200
#
#       geo = new GeoCoder()
#
#       for user in usersArray
#         existingUser = Accounts.findUserByEmail user.email
#         if existingUser
#           # update the user
#           console.log "skipping user"
#         else
#
#           userData =
#             email: user.email
#             profile:
#               name:         user.name
#               createdAt:    new Date user.dateJoined
#               phone:        user.phone
#               website:      user.website
#               deliveryAddress: geo.geocode(user.address)[0]
#
#           if user.producerData?
#             producerData = user.producerData
#
#             userData.profile.companyName = producerData.companyName
#             userData.profile.summary = producerData.description
#             userData.profile.bio = producerData.personalBio
#             userData.profile.bankAccount = producerData.bankAccount
#
#           if user.balance > 0
#             userData.balance = user.balance
#
#           newUserId = Accounts.createUser userData
#
#           if user.user_type.canSell
#             Roles.addUsersToRoles newUserId, ['producer']
#
#           Accounts.sendEnrollmentEmail newUserId
#
#         # next import products
#         products = _.filter productsArray, producer_ID: user._id
#
#         if products.length > 0 && (newUserId || existingUser)
#           for product in products
#             existingProduct = Products.findOne
#               producer: newUserId || existingUser._id
#               name: "#{product.variety} #{product.productName}"
#               stocklevel: product.quantity
#             if existingProduct?
#               console.log "skipping addition of #{product.variety} #{product.productName}"
#             else
#               Products.insert
#                 name: "#{product.variety} #{product.productName}"
#                 producer: newUserId || existingUser._id
#                 producerName: user.name
#                 producerCompanyName: user.producerData.companyName
#                 price: product.price
#                 unitOfMeasure: product.units
#                 category: product.category || 'Produce'
#                 stocklevel: product.quantity
#                 published: true
#                 description: product.description
#                 dateCreated: new Date product.dateUploaded
#                 last_modified: new Date()
#                 ingredients: product.ingredients
#                 certification: name: product.certification || 'none'
#                 minimumOrder: product.minimumOrder
#
#
#
#
#   return