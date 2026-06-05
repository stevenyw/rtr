local data = {Text = "[GLOBAL]: message goes here lol", Color = "#0287FF"} 
game:GetService("MessagingService"):PublishAsync("GlobalWinAnnouncements", game:GetService("HttpService"):JSONEncode(data))
