package service

import (
	"github.com/jorlash/router-hub/service/openaicompat"
	"github.com/jorlash/router-hub/setting/model_setting"
)

func ShouldChatCompletionsUseResponsesPolicy(policy model_setting.ChatCompletionsToResponsesPolicy, channelID int, channelType int, model string) bool {
	return openaicompat.ShouldChatCompletionsUseResponsesPolicy(policy, channelID, channelType, model)
}

func ShouldChatCompletionsUseResponsesGlobal(channelID int, channelType int, model string) bool {
	return openaicompat.ShouldChatCompletionsUseResponsesGlobal(channelID, channelType, model)
}
