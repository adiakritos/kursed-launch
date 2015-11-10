class User < ActiveRecord::Base
    belongs_to :referrer, :class_name => "User", :foreign_key => "referrer_id"
    has_many :referrals, :class_name => "User", :foreign_key => "referrer_id"

    attr_accessible :email

    validates :email, :uniqueness => true, :format => { :with => /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i, :message => "Invalid email format." }
    validates :referral_code, :uniqueness => true

    before_create :create_referral_code
    after_create :send_welcome_email

    REFERRAL_STEPS = [
        {
            'count' => 5,
            "html" => "15% off<br>Entire Purchase",
            "class" => "two",
            "image" =>  ActionController::Base.helpers.asset_path("refer/item-15pct.jpg")
        },
        {
            'count' => 10,
            "html" => "35% off<br>Entire Purchase",
            "class" => "three",
            "image" => ActionController::Base.helpers.asset_path("refer/item-35pct.jpg")
        },
        {
            'count' => 25,
            "html" => "1 Free<br>T-Shirt of your Choice",
            "class" => "four",
            "image" => ActionController::Base.helpers.asset_path("refer/item-1free.jpg")
        },
        {
            'count' => 45,
            "html" => "1 Free<br>T-Shirt,<br>Longsleeve &<br>Hoodie of your Choice",
            "class" => "five",
            "image" => ActionController::Base.helpers.asset_path("refer/item-3free.jpg")
        }
    ]

    private

    def create_referral_code
        referral_code = SecureRandom.hex(5)
        @collision = User.find_by_referral_code(referral_code)

        while !@collision.nil?
            referral_code = SecureRandom.hex(5)
            @collision = User.find_by_referral_code(referral_code)
        end

        self.referral_code = referral_code
    end

    def send_welcome_email
        UserMailer.signup_email(self).deliver
    end
end
