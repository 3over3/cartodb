module Carto
  module UserAuthenticator
    def authenticate(email, password)
      sanitized_input = email.strip.downcase
      if candidate = ::User.filter("email = ? OR username = ?", sanitized_input, sanitized_input).first
        password_locked(candidate) if candidate.locked_password?
        return candidate if valid_password?(candidate, password)
      end
    end

    def valid_password?(candidate, password)
      candidate.crypted_password == password_digest(password, candidate.salt)
    end

    def password_locked(user)
      throw(:warden, action: :password_locked, username: user.username)
    end

    def password_digest(password, salt)
      digest = AUTH_DIGEST
      10.times do
        digest = secure_digest(digest, salt, password, AUTH_DIGEST)
      end
      digest
    end

    def secure_digest(*args)
      Digest::SHA1.hexdigest(args.flatten.join('--'))
    end

    def make_token
      secure_digest(Time.now, (1..10).map { rand.to_s })
    end

    AUTH_DIGEST = '47f940ec20a0993b5e9e4310461cc8a6a7fb84e3'.freeze
  end
end
