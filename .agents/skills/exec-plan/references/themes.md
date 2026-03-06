# Themes

When generating the HTML file, apply a theme to make it visually distinctive and fun. The theme affects colors, typography, decorative elements, and the overall feel of the document.

## Choosing a Theme

If the user specifies `--theme <name>`, use that theme. If no theme is specified, pick one at random.

## Theme List

| Name | Concept |
|------|---------|
| tron | Neon cyan on black, glowing grid lines, sci-fi digital |
| pokemon | Pokedex red and white, playful pixel-art feel |
| shark | Deep ocean blue and steel gray, sharp angular edges |
| miami | Hot pink and teal, art-deco, tropical luxury |
| jungle | Lush greens and earth brown, organic leaf textures |
| space | Deep purple and nebula pink on near-black, starfield |
| retro-arcade | Neon green and magenta on dark, CRT scanline vibe |
| campfire | Warm amber and orange on charcoal, cozy woodsy feel |
| underwater | Aquamarine and deep navy, flowing watery feel |
| cyberpunk | Hot magenta and electric yellow on chrome-dark, glitchy |

## Generating Theme CSS

When building the HTML file, use the theme concept above to generate a complete `<style>` block that styles:

- Background and text colors
- Heading colors and styles
- Sidebar background and link colors
- Phase card borders and backgrounds
- Table header and zebra-stripe colors
- Badge colors (risk and complexity badges keep their semantic colors but adapt to the theme)
- Progress bar fill color
- Collapsible section header styling
- Font choice (pick a Google Font that fits the concept)
- Any decorative accents that fit the theme concept (subtle — don't overpower the content)

Keep the base layout from `html-template.html` intact. The theme CSS only overrides visual styling, not structure.
