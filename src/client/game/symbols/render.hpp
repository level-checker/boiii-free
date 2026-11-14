#pragma once

#include <game/symbols/sym_include.hpp>

namespace game {
namespace render {
// Rendering
WEAK symbol<void(const char *text, int, const uint32_t *font, float x, float y,
                 float xScale, float yScale, float, const vec4_t *color,
                 itemTextStyle textStyle)>
    R_AddCmdDrawText{0x141CCD500, 0x0};
WEAK symbol<int32_t(LocalClientNum_t localClientNum, const char *text,
                    int32_t maxChars, const uint32_t *font)>
    R_TextWidth{0x141C9EEF0, 0x0};
} // namespace render
} // namespace game
