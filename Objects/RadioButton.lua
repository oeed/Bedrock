BackgroundColour = colours.white
ActiveBackgroundColour = colours.green
TextColour = colours.black
SelectedText = "#"
UnselectedText = "o"
Text = ""
Friends = ""
AutoWidth = true
Selected = false
Enabled = true

OnUpdate = function(self, value)
  if value == "Text" and self.AutoWidth then
    self.Width = #self.Text + 2
  end

  if value == "Selected" and self.Selected and self.Bedrock and self.Bedrock.View then
    if type(self.Friends) == "string" then
      local friend = self.Bedrock:GetObject(self.Friends)

      if friend and friend.Type == "RadioButton" and friend.Enabled then
          friend.Selected = false
      end
    elseif type(self.Friends) == "table" then
      for _,v in ipairs(self.Friends) do
        local friend = self.Bedrock:GetObject(v)

        if friend and friend.Type == "RadioButton" and friend.Enabled then
            friend.Selected = false
        end
      end
    end
  end
end

OnLoad = function(self)
  if self.AutoWidth then
    self.Width = #self.Text + 2
  end

  self.Height = 1
end

OnDraw = function(self, x, y)
  Drawing.DrawCharacters(x, y, self.Selected and self.SelectedText or self.UnselectedText, self.Selected and colours.green or colours.lightGrey, colours.white)
  Drawing.DrawCharacters(x + 2, y, self.Text, self.TextColour, colours.transparent)
end

Click = function(self, event, side, x, y)
  if self.Visible and not self.IgnoreClick and self.Enabled and event ~= "mouse_scroll" then
    self.Selected = true

    if self.OnSelectionChange then
      self:OnSelectionChange()
    end

    return true
  end
end
