package controller

import (
	"strings"

	"github.com/jorlash/router-hub/common"
	"github.com/jorlash/router-hub/setting/system_setting"
)

func paymentReturnPath(suffix string) string {
	base := strings.TrimRight(system_setting.ServerAddress, "/")
	return base + common.ThemeAwarePath(suffix)
}
