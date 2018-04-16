AdminUser.find_or_create_by(email: 'example@mail.ru',
                            password: '1234567890')
admin = AdminUser.find_by(email: 'example@mail.ru')
AdminUser.create(email: 'example@mail.ru', assword: '1234567890') unless admin
