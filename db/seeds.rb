Crisis.create!(name: "Chair",
               committee: "Future of Chinese International Relations",
               position: "Crisis",
               email: "cchair@iro.org",
               password: "allhailbillsu",
               password_confirmation: "allhailbillsu",
               admin: true,
               activated: true,
               activated_at: Time.zone.now)
(1..5).each do |n|
Crisis.create!(name: "Crisis #{n}",
               committee: "Future of Chinese International Relations",
               position: "Crisis",
               email: "ccrisis#{n}@iro.org",
               password: "allhailbillsu",
               password_confirmation: "allhailbillsu",
               admin: false,
               activated: true,
               activated_at: Time.zone.now)
end

Crisis.create!(name: "Chair",
               committee: "Peloponnesian War",
               position: "Crisis",
               email: "pchair@iro.org",
               password: "allhailaustin",
               password_confirmation: "allhailaustin",
               admin: true,
               activated: true,
               activated_at: Time.zone.now)

(1..5).each do |n|
Crisis.create!(name: "Crisis #{n}",
               committee: "Peloponnesian War",
               position: "Crisis",
               email: "pcrisis#{n}@iro.org",
               password: "allhailaustin",
               password_confirmation: "allhailaustin",
               admin: false,
               activated: true,
               activated_at: Time.zone.now)
end
