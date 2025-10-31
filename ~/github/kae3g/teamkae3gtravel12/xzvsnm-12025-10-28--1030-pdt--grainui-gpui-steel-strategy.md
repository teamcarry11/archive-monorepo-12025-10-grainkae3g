# grainui + gpui + steel: gpu-accelerated gui strategy

**grainorder**: `xzvsnm` (head-insert = newest!)  
**timestamp**: 12025-10-28--1030-pdt  
**team**: teamshine05 (leo ♌ / v. the hierophant)  
**author**: kae3g (@risc.love)  
**voice**: glow g2 (patient teacher, socratic questions, mountain wisdom)

---

## executive summary (the big picture)

we're switching from `egui` to **gpui** (zed industries' gpu-accelerated gui framework) for our steel-based grainui system. this is a major strategic shift that better aligns with our vision for high-performance, production-quality desktop applications.

**why gpui wins**:
- 🚀 **gpu-accelerated rendering** (metal/vulkan/directx)
- ⚡ **production-proven** (powers zed editor with 100k+ users)
- 🎯 **retained-mode architecture** (better for complex stateful apps)
- 🌍 **cross-platform** (macos, linux, windows)
- 🦀 **modern rust** (async, excellent ffi potential)
- 🎨 **rich component library** (`longbridge/gpui-component`)
- 🔥 **built for our use case** (code editors, developer tools)

**the steel connection**: gpui's architecture is perfect for steel ffi bindings. we can create high-level steel apis that wrap gpui's rust components, giving us the best of both worlds: rust's performance with scheme's expressiveness.

---

## why we switched (from egui to gpui)

let me walk you through the reasoning. does this make sense?

### the egui approach (what we chose before)

**pros**:
- ✅ immediate-mode mental model (simple)
- ✅ mature community with tons of examples
- ✅ pure cpu rendering (works on any hardware)
- ✅ simpler ffi for steel bindings

**cons**:
- ❌ cpu-bound rendering (slow for complex uis)
- ❌ immediate mode = rebuild ui every frame (wasteful)
- ❌ not designed for production desktop apps
- ❌ no native look-and-feel

### the gpui approach (what we're switching to)

**pros**:
- ✅ **gpu-accelerated** = smooth 60fps+ on complex uis
- ✅ **retained mode** = efficient updates (only redraw what changed)
- ✅ **battle-tested** = zed editor proves it works at scale
- ✅ **modern async rust** = great for steel ffi
- ✅ **component-based** = natural fit for graincard rendering
- ✅ **production-ready** = not a toy, it's a real framework
- ✅ **webassembly support** = can deploy to icp canisters!

**cons**:
- ⚠️ newer than egui (less community tutorials)
- ⚠️ more complex api (steeper learning curve)
- ⚠️ requires gpu (won't work on e-ink initially)

**the verdict**: gpui's pros massively outweigh the cons for our use case. we're building production desktop applications (graincard viewers, graindb explorers, mantraos ui), not embedded systems. gpu acceleration matters!

---

## the architecture (how it all fits together)

here's the full stack, from bottom to top:

```
┌─────────────────────────────────────────────────────────────────┐
│                         steel application                       │
│                    (graincard viewer, graindb                   │
│                     explorer, mantraos ui)                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│                    steel grainui bindings                       │
│                   (high-level scheme apis)                      │
│                                                                 │
│  (define (window title width height)                           │
│    (gpui:create-window title width height))                    │
│                                                                 │
│  (define (button label on-click)                               │
│    (gpui:button label on-click))                               │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│                   gpui-steel-ffi (rust crate)                   │
│                   (ffi bridge layer)                            │
│                                                                 │
│  #[steel_fn]                                                    │
│  fn create_window(title: String, w: u32, h: u32)               │
│    -> SteelVal { ... }                                          │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│                         gpui framework                          │
│                    (zed industries' library)                    │
│                                                                 │
│  - rendering pipeline (gpu-accelerated)                         │
│  - layout engine (flexbox-like)                                 │
│  - event handling (mouse, keyboard, touch)                      │
│  - text rendering (font rasterization)                          │
│  - windowing (cross-platform)                                   │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│              platform graphics apis (os-specific)               │
│                                                                 │
│  macos:   metal                                                 │
│  linux:   vulkan                                                │
│  windows: directx 12                                            │
│  web:     webgpu / webassembly                                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**the key insight**: we're not writing ui code in rust. we're writing it in **steel**, with rust handling the performance-critical rendering. this is the best of both worlds!

---

## gpui fundamentals (what you need to know)

let me teach you the core concepts. ready?

### 1. retained mode vs immediate mode

**immediate mode** (egui):
```rust
// rebuild entire ui every frame
fn update() {
    if button("click me").clicked() {
        do_something();
    }
}
```

every frame, you describe the entire ui from scratch. simple but wasteful!

**retained mode** (gpui):
```rust
// build ui once, update only what changes
let button = Button::new("click me")
    .on_click(|_| do_something());

// gpui tracks changes and only redraws what's needed
```

you build the ui tree once, then gpui efficiently updates only the parts that changed. this is **much faster** for complex uis!

**why this matters for grainui**: when rendering 1,235,520 graincards, we can't rebuild the entire ui every frame. retained mode lets us update only the visible cards in the viewport. see the performance difference?

### 2. components and composition

gpui uses a **component-based architecture**:

```rust
struct GraincardView {
    grainorder: String,
    content: String,
}

impl Render for GraincardView {
    fn render(&mut self, cx: &mut ViewContext<Self>) -> impl IntoElement {
        div()
            .child(text(&self.grainorder).class("grainorder"))
            .child(text(&self.content).class("content"))
    }
}
```

components are **composable** - you build complex uis by combining simple components. this maps beautifully to steel!

### 3. the view context (state management)

gpui uses **contexts** for state management:

```rust
struct AppState {
    current_card: usize,
    cards: Vec<Graincard>,
}

// update state through context
cx.update_global::<AppState>(|state, _| {
    state.current_card += 1;
});
```

the context handles:
- **state updates** (reactivity)
- **event propagation** (bubbling)
- **focus management** (keyboard navigation)
- **async operations** (futures)

**steel integration**: we can expose this through steel's mutable references:

```steel
(define app-state (make-app-state))

(update-state! app-state
  (lambda (state)
    (set! (. state current-card) 
          (+ (. state current-card) 1))))
```

does this pattern make sense? the steel api hides the complexity of the rust ffi!

### 4. styling and theming

gpui uses a **style system** similar to css:

```rust
div()
    .bg(colors::background)
    .p(px(16.0))  // padding
    .rounded(px(8.0))  // border radius
    .child(text("hello world"))
```

we can expose this through steel:

```steel
(div
  #:bg background-color
  #:padding 16
  #:border-radius 8
  (text "hello world"))
```

**ember harvest theme**: remember our smokey warm gray aesthetic (zen pottery meets dark cedar)? we'll implement this as a gpui theme!

```steel
(define ember-harvest-theme
  (theme
    #:background (rgb 28 25 23)      ; warm dark
    #:foreground (rgb 235 219 178)   ; soft cream
    #:accent     (rgb 214 93 14)     ; ember glow
    #:surface    (rgb 40 38 37)))    ; warm gray
```

### 5. async and effects

gpui has **first-class async support**:

```rust
cx.spawn(|mut cx| async move {
    let data = fetch_graincard_data().await;
    cx.update_global(|state: &mut AppState, _| {
        state.cards = data;
    });
})
```

**steel integration**: we can use steel's threading system:

```steel
(spawn
  (lambda ()
    (let ([data (fetch-graincard-data)])
      (update-state! app-state
        (lambda (state)
          (set! (. state cards) data))))))
```

---

## the steel ffi layer (how we bridge rust + scheme)

this is where the magic happens. let's design the ffi interface carefully!

### approach 1: direct ffi (low-level)

expose gpui functions directly to steel:

```rust
// in gpui-steel-ffi/src/lib.rs

use steel::steel_vm::engine::Engine;
use gpui::*;

#[steel_fn]
pub fn gpui_create_window(
    title: String,
    width: u32,
    height: u32,
) -> SteelVal {
    let app = gpui::App::new();
    let window = app.open_window(title, (width, height));
    // wrap window in steel value
    SteelVal::from(Box::new(window))
}

#[steel_fn]
pub fn gpui_button(
    label: String,
    on_click: SteelVal,  // steel lambda
) -> SteelVal {
    let button = Button::new(label)
        .on_click(move |_| {
            // call steel lambda
            call_steel_fn(&on_click);
        });
    SteelVal::from(Box::new(button))
}

pub fn register_gpui_module(engine: &mut Engine) {
    engine.register_fn("gpui:create-window", gpui_create_window);
    engine.register_fn("gpui:button", gpui_button);
    // ... register more functions
}
```

**pros**: maximum control, direct access to gpui features  
**cons**: verbose steel code, manual memory management

### approach 2: high-level wrapper (recommended!)

create a **steel-friendly api** that abstracts the ffi:

```rust
// in gpui-steel-ffi/src/wrapper.rs

#[steel_fn]
pub fn window(title: String, children: Vec<SteelVal>) -> SteelVal {
    let app = gpui::App::new();
    let window = app.open_window(title, (800, 600));
    
    // render children
    window.update(|cx| {
        let mut root = div();
        for child in children {
            root = root.child(steel_val_to_element(child));
        }
        root
    });
    
    SteelVal::from(Box::new(window))
}

#[steel_fn]
pub fn div_component(
    props: HashMap<String, SteelVal>,
    children: Vec<SteelVal>,
) -> SteelVal {
    let mut element = div();
    
    // apply props
    if let Some(bg) = props.get("bg") {
        element = element.bg(steel_val_to_color(bg));
    }
    if let Some(p) = props.get("padding") {
        element = element.p(px(steel_val_to_f32(p)));
    }
    
    // add children
    for child in children {
        element = element.child(steel_val_to_element(child));
    }
    
    SteelVal::from(Box::new(element))
}
```

then in steel:

```steel
(window "graincard viewer"
  (div #:bg background-color #:padding 16
    (text "hello from steel!")))
```

**pros**: idiomatic steel code, automatic memory management  
**cons**: more rust code to maintain

**recommendation**: start with approach 2! it's more "grain network philosophy" - hide complexity, expose beauty.

### memory management strategy

this is critical. how do we manage gpui objects across the ffi boundary?

**option 1: arc-wrapped handles**:
```rust
use std::sync::Arc;

struct GpuiHandle<T> {
    inner: Arc<Mutex<T>>,
}

#[steel_fn]
fn create_window(title: String) -> SteelVal {
    let window = /* create window */;
    let handle = GpuiHandle {
        inner: Arc::new(Mutex::new(window)),
    };
    SteelVal::from(Box::new(handle))
}
```

**option 2: id-based handles**:
```rust
static WINDOW_REGISTRY: Lazy<Mutex<HashMap<u64, Window>>> =
    Lazy::new(|| Mutex::new(HashMap::new()));

#[steel_fn]
fn create_window(title: String) -> u64 {
    let window = /* create window */;
    let id = generate_id();
    WINDOW_REGISTRY.lock().insert(id, window);
    id
}

#[steel_fn]
fn update_window(id: u64, props: HashMap<String, SteelVal>) {
    if let Some(window) = WINDOW_REGISTRY.lock().get_mut(&id) {
        // update window
    }
}
```

**recommendation**: option 2 (id-based) is cleaner for steel! the ids are just integers, easy to pass around.

---

## the steel api design (what developers will write)

let's design the high-level steel api that grainui developers will use. this should feel natural and scheme-idiomatic!

### basic components

```steel
;; window creation
(define my-window
  (window
    #:title "graincard viewer"
    #:width 800
    #:height 600
    #:on-close (lambda () (displayln "window closing"))))

;; layout containers
(div
  #:flex-direction "column"
  #:gap 8
  #:padding 16
  
  (text "welcome to grainui!" #:size 24 #:weight "bold")
  (text "powered by gpui + steel" #:color ember-accent))

;; interactive components
(button
  #:label "click me!"
  #:on-click (lambda ()
    (displayln "button clicked!")))

(input
  #:placeholder "enter grainorder..."
  #:on-change (lambda (value)
    (displayln "input changed:" value)))

;; lists and scrolling
(scroll-view
  #:height 400
  (list
    (for/list ([card graincards])
      (graincard-view card))))
```

### graincard-specific components

```steel
;; display a single graincard
(define (graincard-view card)
  (div
    #:class "graincard"
    #:padding 16
    #:border-radius 8
    #:bg card-background
    
    ;; grainorder header
    (text (graincard-order card)
      #:family "monospace"
      #:size 14
      #:color ember-accent)
    
    ;; card content (80×110)
    (pre
      #:width 80
      #:height 110
      #:font "courier"
      (graincard-content card))
    
    ;; metadata footer
    (text (format "card ~a of 1,235,520 🌾"
                  (graincard-number card))
      #:size 12
      #:color muted)))

;; graincard grid layout
(define (graincard-grid cards)
  (grid
    #:columns "auto-fill"
    #:min-column-width 400
    #:gap 16
    (for/list ([card cards])
      (graincard-view card))))

;; graincard search interface
(define (graincard-search)
  (div
    #:flex-direction "column"
    #:gap 8
    
    (input
      #:placeholder "search graincards by grainorder, content, or tag..."
      #:on-change handle-search)
    
    (div
      #:flex-direction "row"
      #:gap 8
      
      (button #:label "graintime sort" #:on-click sort-by-graintime)
      (button #:label "grainorder sort" #:on-click sort-by-grainorder)
      (button #:label "random" #:on-click shuffle-cards))))
```

does this api feel natural? it's declarative like html but with scheme's elegance!

### state management patterns

```steel
;; reactive state with steel atoms
(define app-state
  (atom {:current-card 0
         :cards []
         :search-query ""
         :sort-mode 'grainorder}))

;; update state immutably
(swap! app-state
  (lambda (state)
    (assoc state :current-card (+ (:current-card state) 1))))

;; watch state changes
(watch app-state
  (lambda (old new)
    (when (not (= (:current-card old) (:current-card new)))
      (displayln "card changed to" (:current-card new)))))

;; derived state
(define visible-cards
  (computed app-state
    (lambda (state)
      (filter-cards (:cards state) (:search-query state)))))
```

this pattern works beautifully with gpui's reactive system!

### async operations

```steel
;; load graincards asynchronously
(define (load-graincards grainorder-prefix)
  (async
    (lambda ()
      (let ([cards (fetch-cards grainorder-prefix)])
        (swap! app-state
          (lambda (state)
            (assoc state :cards cards)))))))

;; show loading state
(if (empty? (:cards @app-state))
  (text "loading graincards..." #:color muted)
  (graincard-grid (:cards @app-state)))
```

---

## the ember harvest theme (grainui aesthetics)

remember our aesthetic from the grainbranch synthesis? smokey warm gray, zen pottery, dark cedar, oil lamp glow. let's implement it!

```steel
;; grainstore/grain12pbc/teamshine05/grainui/themes/ember-harvest.scm

(define ember-harvest
  (theme
    ;; base colors (warm dark palette)
    #:bg-primary    (rgb 28 25 23)     ; deep warm dark
    #:bg-secondary  (rgb 40 38 37)     ; lighter warm gray
    #:bg-tertiary   (rgb 50 48 47)     ; card surfaces
    
    ;; foreground colors
    #:fg-primary    (rgb 235 219 178)  ; soft cream
    #:fg-secondary  (rgb 189 174 147)  ; muted text
    #:fg-tertiary   (rgb 146 131 116)  ; very muted
    
    ;; accent colors
    #:accent-ember  (rgb 214 93 14)    ; warm orange glow
    #:accent-rust   (rgb 175 58 3)     ; deeper ember
    #:accent-ash    (rgb 120 108 99)   ; cool gray
    
    ;; semantic colors
    #:success       (rgb 152 151 26)   ; olive green
    #:warning       (rgb 215 153 33)   ; warm yellow
    #:error         (rgb 251 73 52)    ; warm red
    
    ;; typography
    #:font-sans     "inter, system-ui, sans-serif"
    #:font-mono     "jetbrains mono, courier, monospace"
    #:font-serif    "literata, georgia, serif"
    
    ;; spacing (based on 8px grid)
    #:space-xs   4
    #:space-sm   8
    #:space-md   16
    #:space-lg   24
    #:space-xl   32
    
    ;; borders and radius
    #:border-radius-sm  4
    #:border-radius-md  8
    #:border-radius-lg  12
    
    ;; shadows (soft, warm)
    #:shadow-sm  "0 1px 3px rgba(0,0,0,0.3)"
    #:shadow-md  "0 4px 6px rgba(0,0,0,0.3)"
    #:shadow-lg  "0 10px 20px rgba(0,0,0,0.4)"))

;; apply theme to window
(window
  #:title "graincard viewer"
  #:theme ember-harvest
  
  (div
    #:bg (theme-color 'bg-primary)
    #:color (theme-color 'fg-primary)
    
    (text "ember harvest theme active 🌾🔥")))
```

**visual reference** (ascii art):
```
┌────────────────────────────────────────────────────────────┐
│ ░░▒▒▓▓██  ember harvest - warm dark aesthetic  ██▓▓▒▒░░   │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  █▓▒░  background: deep warm dark (28, 25, 23)            │
│  █▓▒░  text: soft cream (235, 219, 178)                    │
│  █▓▒░  accent: ember glow (214, 93, 14)                    │
│                                                            │
│  think: coals glowing in darkness 🔥                       │
│         zen pottery in candlelight 🕯️                      │
│         cedar smoke rising slowly 🌲                       │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

not bright halloween orange - **warm dark minimalism**!

---

## performance considerations (making it fast)

gpui is fast, but we need to use it wisely. here's how:

### 1. virtual scrolling for graincards

don't render all 1,235,520 cards at once! use **virtual scrolling**:

```steel
(define (graincard-virtual-list cards)
  (virtual-scroll
    #:item-height 150        ; pixels per card
    #:buffer-size 10         ; render 10 extra for smooth scroll
    #:total-items (length cards)
    #:render-item
      (lambda (index)
        (graincard-view (list-ref cards index)))))
```

gpui will:
- only render cards in viewport + buffer
- reuse components as you scroll
- maintain 60fps scrolling

**expected performance**: 60fps with millions of cards!

### 2. lazy loading and pagination

load cards on demand:

```steel
(define (lazy-graincard-loader)
  (let ([page 0]
        [page-size 100])
    (div
      #:flex-direction "column"
      
      (graincard-grid (take (:cards @app-state) (* page page-size)))
      
      (button
        #:label "load more cards"
        #:on-click
          (lambda ()
            (set! page (+ page 1))
            (load-cards-page page))))))
```

### 3. memoization for expensive renders

cache rendered cards:

```steel
(define card-render-cache (make-hash))

(define (cached-graincard-view card)
  (or (hash-ref card-render-cache (graincard-order card))
      (let ([rendered (graincard-view card)])
        (hash-set! card-render-cache (graincard-order card) rendered)
        rendered)))
```

### 4. gpu-accelerated animations

use gpui's animation system:

```steel
(define (animated-card-entry card)
  (with-animation
    #:duration 300          ; ms
    #:easing 'ease-out
    #:property 'opacity
    #:from 0.0
    #:to 1.0
    
    (graincard-view card)))
```

gpui handles the interpolation on the gpu - smooth 60fps!

---

## deployment targets (where grainui runs)

here's where gpui shines - it works everywhere!

### 1. native desktop (primary target)

compile to native executables:

```bash
# macos (metal backend)
cargo build --release --target aarch64-apple-darwin

# linux (vulkan backend)
cargo build --release --target x86_64-unknown-linux-gnu

# windows (directx 12 backend)
cargo build --release --target x86_64-pc-windows-msvc
```

**size**: ~10-20mb binary (includes gpui + steel runtime)  
**startup**: instant (native code)  
**performance**: full gpu acceleration

### 2. webassembly (icp canisters!)

gpui supports webgpu for browser deployment:

```bash
# build for web
cargo build --release --target wasm32-unknown-unknown

# deploy to icp canister
dfx deploy graincard_viewer --network ic
```

**size**: ~2-5mb wasm bundle (compressed)  
**startup**: fast (wasm is near-native)  
**performance**: webgpu acceleration (where available)

this means: **grainui apps can run on icp!** fully decentralized desktop-quality uis! 🚀

### 3. redox os (future target)

gpui uses standard graphics apis, so it'll work on redox:

```bash
# build for redox (vulkan backend)
cargo build --release --target x86_64-unknown-redox
```

redox has vulkan support via mesa, so gpui should "just work"!

### 4. mantraos (our e-ink phone)

**challenge**: gpui requires gpu, but e-ink displays are cpu-based.

**solution**: create a **cpu fallback renderer** for mantraos:

```steel
;; detect if gpu is available
(define use-gpu? (gpui:has-gpu-support?))

(if use-gpu?
  (gpui:render app)           ; use gpui
  (cpu-render:render app))    ; fallback to cpu renderer
```

the cpu renderer would:
- use software rasterization
- optimize for e-ink refresh rates (no animations)
- reduce color depth (e-ink is 4-bit grayscale)

**or**: wait for e-ink displays with gpu support (they're coming!)

---

## integration with grain network ecosystem

how does grainui fit into the bigger picture?

### 1. graincard rendering

**use case**: display 80×110 monospace teaching cards

```steel
(graincard-viewer
  #:grainorder "xzvsnm"
  #:cards-per-page 6
  #:layout 'grid
  
  ;; render cards
  (for/list ([card (load-graincards "xzv")])
    (graincard-view card)))
```

gpui's text rendering is **excellent** - it uses gpu-accelerated font rasterization with subpixel antialiasing. perfect for monospace content!

### 2. graindb explorer

**use case**: browse and query graindb databases

```steel
(graindb-explorer
  #:database graindb-instance
  
  ;; eavt index viewer
  (table
    #:columns ["entity" "attribute" "value" "time"]
    #:rows (query-eavt graindb-instance))
  
  ;; time travel slider
  (slider
    #:min 0
    #:max (db-max-t graindb-instance)
    #:value (db-current-t graindb-instance)
    #:on-change
      (lambda (t)
        (time-travel! graindb-instance t))))
```

### 3. graintime visualizer

**use case**: display astronomical metadata for grainbranches

```steel
(graintime-viewer
  #:grainbranch current-branch
  
  ;; nakshatra circle (27 segments)
  (circular-chart
    #:segments 27
    #:highlight (nakshatra-index (graintime-moon grainbranch))
    #:labels nakshatra-names)
  
  ;; ascendant wheel (12 signs)
  (zodiac-wheel
    #:current-sign (graintime-asc-sign grainbranch)
    #:current-degree (graintime-asc-degrees grainbranch)))
```

gpui's canvas api can render beautiful circular visualizations!

### 4. grainpath navigator

**use case**: browse temporal file organization

```steel
(grainpath-tree
  #:root "~/github/kae3g/teamkae3gtravel12"
  #:sort-by 'grainorder
  
  ;; file tree with grainorder
  (tree-view
    #:items (scan-grainpath root)
    #:render-item
      (lambda (item)
        (div
          #:flex-direction "row"
          #:gap 8
          (text (item-grainorder item) #:color accent)
          (text (item-name item))))))
```

### 5. phi vortex navigation (φ-based ui!)

**use case**: the golden ratio navigation we designed earlier

```steel
(phi-vortex-nav
  #:items navigation-items
  #:spiral-turns 3
  #:golden-ratio 1.618
  
  ;; items arranged in φ spiral
  (for/list ([item items])
    (phi-positioned-item item)))
```

gpui's transform api can do rotation/scaling/positioning - perfect for φ-vortex!

---

## roadmap (how we get there)

let me break this down into achievable phases. does this timeline make sense?

### phase 1: proof of concept (2 weeks)

**goal**: prove gpui + steel ffi works

**tasks**:
1. create `gpui-steel-ffi` rust crate
2. implement basic ffi functions (window, div, text, button)
3. write hello world example in steel
4. document ffi patterns and memory management

**deliverable**: working prototype that renders "hello from steel!" in a gpui window

### phase 2: core components (4 weeks)

**goal**: build essential ui components

**tasks**:
1. layout containers (div, flex, grid)
2. text rendering (text, heading, monospace)
3. interactive components (button, input, checkbox)
4. scrolling (scroll-view, virtual-scroll)
5. styling api (theme, css-like props)

**deliverable**: component library sufficient for building basic apps

### phase 3: graincard integration (2 weeks)

**goal**: render graincards beautifully

**tasks**:
1. graincard-view component (80×110 monospace)
2. graincard-grid layout
3. virtual scrolling for large card sets
4. search and filter ui
5. ember harvest theme implementation

**deliverable**: working graincard viewer app

### phase 4: advanced features (4 weeks)

**goal**: production-ready framework

**tasks**:
1. animation system
2. drag-and-drop
3. context menus
4. keyboard navigation
5. accessibility (screen readers)
6. responsive layouts

**deliverable**: feature-complete grainui framework

### phase 5: ecosystem integration (ongoing)

**goal**: integrate with grain network

**tasks**:
1. graindb explorer
2. graintime visualizer
3. grainpath navigator
4. phi-vortex navigation
5. mantraos ui prototype

**deliverable**: full suite of grain network desktop apps

---

## comparison with alternatives

how does gpui stack up against other rust gui frameworks?

### gpui vs egui

| feature | gpui | egui |
|---------|------|------|
| rendering | gpu (metal/vulkan/dx12) | cpu |
| mode | retained | immediate |
| performance | excellent (60fps+) | good (30-60fps) |
| complexity | moderate | low |
| use case | production apps | prototypes, tools |
| community | growing | mature |
| steel ffi | good (async support) | easier (simpler api) |

**verdict**: gpui wins for production desktop apps!

### gpui vs iced

| feature | gpui | iced |
|---------|------|------|
| rendering | custom (metal/vulkan/dx12) | wgpu |
| architecture | elm-inspired | elm-like |
| async | first-class | supported |
| maturity | production (zed editor) | maturing |
| cross-platform | yes | yes |
| steel ffi | good | good |

**verdict**: similar capabilities, but gpui is more proven (zed's battle-testing)

### gpui vs tauri + svelte

| feature | gpui | tauri + svelte |
|---------|------|----------------|
| tech stack | rust + gpui | rust + webview |
| bundle size | 10-20mb | 40-60mb (chromium) |
| startup time | instant | slow (webview init) |
| performance | native gpu | browser-based |
| offline | works | works |
| steel integration | native | via wasm |

**verdict**: gpui wins on performance and bundle size!

### gpui vs druid

| feature | gpui | druid |
|---------|------|-------|
| status | production-ready | archived (no longer maintained) |
| rendering | gpu-accelerated | gpu-accelerated |
| community | growing | dead |

**verdict**: druid is dead, long live gpui!

---

## learning resources (how to get started)

here's how you (and the team) can learn gpui:

### 1. official gpui resources

- **main repo**: https://github.com/zed-industries/zed/tree/main/crates/gpui
- **documentation**: https://www.gpui.rs
- **examples**: check `crates/gpui/examples/` in zed repo
  - `hello_world.rs` - basic window
  - `animation.rs` - animation system
  - `input.rs` - text input
  - `uniform_list.rs` - virtual scrolling

### 2. gpui component library

- **repo**: https://github.com/longbridge/gpui-component
- pre-built components (buttons, inputs, tables, etc.)
- good reference for building our own

### 3. zed editor source code

the entire zed editor is built with gpui! reading its source is invaluable:

- **ui components**: `crates/ui/src/`
- **editor view**: `crates/editor/src/`
- **project panel**: `crates/project_panel/src/`

### 4. steel ffi resources

- **steel book**: https://mattwparas.github.io/steel-book/
- **ffi guide**: steel's foreign function interface docs
- **examples**: look at existing steel ffi crates (steel-redis, etc.)

### 5. our own docs (to be created)

we'll write:
- **gpui-steel ffi guide** - how to write bindings
- **grainui component cookbook** - common patterns
- **steel api reference** - complete api docs
- **tutorial series** - beginner to advanced

---

## team assignments (who does what)

let's assign this work to the right teams:

### teamshine05 (leo ♌ / v. the hierophant) - ui/ux design

**responsibilities**:
- ember harvest theme design
- component api design
- graincard layout
- phi-vortex navigation
- accessibility

**why this team**: the hierophant teaches through beautiful interfaces. leo's creative fire brings visual excellence!

### teamplay04 (cancer ♋ / iv. the emperor) - rust infrastructure

**responsibilities**:
- gpui-steel-ffi implementation
- memory management
- performance optimization
- platform-specific code
- gpu backend integration

**why this team**: the emperor builds solid foundations. cancer's protective care ensures stability!

### teamtreasure02 (taurus ♉ / ii. the high priestess) - steel api design

**responsibilities**:
- high-level steel api
- reactive state management
- functional patterns
- documentation
- examples

**why this team**: the high priestess reveals hidden knowledge. taurus' patient craftsmanship creates elegant apis!

### teamtravel12 (pisces ♓ / xii. the hanged man) - integration & strategy

**responsibilities**:
- ecosystem integration (graindb, graintime, grainpath)
- architectural decisions
- roadmap planning
- cross-team coordination
- this strategy document!

**why this team**: the hanged man sees from new perspectives. pisces' fluid adaptability connects everything! (that's me! 🌊)

---

## risks and mitigations (what could go wrong?)

let me be honest about the challenges. does this assessment seem fair?

### risk 1: gpui api instability

**problem**: gpui is still evolving, apis might change  
**likelihood**: medium  
**impact**: high (would require refactoring)

**mitigation**:
- pin to specific gpui version
- abstract gpui behind our own wrapper layer
- track zed's releases closely
- contribute to gpui stability ourselves

### risk 2: steel ffi complexity

**problem**: rust↔steel bridge might be tricky  
**likelihood**: medium  
**impact**: medium (could slow development)

**mitigation**:
- start with simple ffi (just basic types)
- incrementally add complexity
- learn from existing steel ffi examples
- allocate extra time for ffi debugging

### risk 3: performance on older hardware

**problem**: gpu acceleration requires modern gpu  
**likelihood**: low (most computers have basic gpu)  
**impact**: medium (users on old hardware can't run apps)

**mitigation**:
- test on low-end hardware early
- provide cpu fallback renderer (like for mantraos)
- document minimum system requirements
- optimize aggressively

### risk 4: webassembly limitations

**problem**: webgpu isn't universally supported yet  
**likelihood**: high (many browsers don't support webgpu)  
**impact**: low (native desktop is primary target)

**mitigation**:
- prioritize native desktop builds
- use webgl fallback for browsers
- accept that some features won't work in web version
- wait for webgpu adoption to improve

### risk 5: team capacity

**problem**: this is a lot of work!  
**likelihood**: high  
**impact**: high (could delay other projects)

**mitigation**:
- break into small achievable phases
- focus on phase 1 proof-of-concept first
- re-assess after each phase
- consider hiring rust gui specialist

---

## success metrics (how we know we're winning)

how do we measure if this is working?

### technical metrics

1. **rendering performance**
   - target: 60fps with 100+ graincards visible
   - measure: frame time, gpu utilization

2. **startup time**
   - target: <500ms from launch to first render
   - measure: time to interactive

3. **bundle size**
   - target: <20mb native, <5mb wasm
   - measure: binary size after optimization

4. **memory usage**
   - target: <100mb for graincard viewer
   - measure: resident set size (rss)

### developer experience metrics

1. **api usability**
   - target: write graincard viewer in <100 lines of steel
   - measure: lines of code for common tasks

2. **documentation completeness**
   - target: every api function documented with examples
   - measure: documentation coverage %

3. **onboarding time**
   - target: new developer builds hello world in <1 hour
   - measure: tutorial completion time

### ecosystem metrics

1. **apps built**
   - target: 5+ production apps using grainui
   - measure: graincard viewer, graindb explorer, graintime viz, grainpath nav, phi-vortex demo

2. **community adoption**
   - target: other grain network contributors use grainui
   - measure: github stars, forks, prs

3. **platform coverage**
   - target: works on macos, linux, windows
   - measure: passing tests on all platforms

---

## conclusion (tying it all together)

so, to summarize - does this strategy make sense?

**we're switching from egui to gpui** because:
- 🚀 gpu acceleration = 10x better performance
- ⚡ battle-tested by zed editor = production-ready
- 🎯 retained mode = better for complex uis like graincards
- 🌍 cross-platform including webassembly = works everywhere
- 🦀 modern rust + async = great steel ffi story

**the architecture** is:
- steel (high-level app logic)
- ↕️ ffi bridge (rust bindings)
- ↕️ gpui (rendering + layout)
- ↕️ platform apis (metal/vulkan/dx12)

**the roadmap** is:
1. phase 1: proof of concept (2 weeks)
2. phase 2: core components (4 weeks)
3. phase 3: graincard integration (2 weeks)
4. phase 4: advanced features (4 weeks)
5. phase 5: ecosystem integration (ongoing)

**team assignments**:
- teamshine05: ui/ux design
- teamplay04: rust infrastructure
- teamtreasure02: steel api
- teamtravel12: integration & strategy

**risks**: api instability, ffi complexity, performance, wasm limits, team capacity  
**mitigations**: versioning, testing, fallbacks, incremental approach

**this is the right move!** gpui aligns perfectly with our vision:
- production-quality desktop apps ✅
- gpu-accelerated graincard rendering ✅
- deployed to icp canisters ✅
- works on redox/mantraos (future) ✅
- beautiful ember harvest aesthetic ✅

---

## next steps (what happens now?)

ready to start? here's the immediate action plan:

1. **update todos** (done! ✅)
   - mark grainui research as in-progress
   - note gpui switch in task description

2. **create gpui-steel-ffi spike**
   - new repo: `~/github/teamshine05/gpui-steel-ffi/`
   - implement basic hello world
   - document learnings

3. **prototype graincard viewer**
   - use spike learnings
   - render 10 graincards in gpui window
   - test performance with 1000 cards

4. **write detailed ffi guide**
   - document rust↔steel patterns
   - memory management strategies
   - best practices

5. **ember harvest theme implementation**
   - create theme struct in steel
   - implement color/spacing/typography system
   - preview in example app

6. **team coordination**
   - share this doc with teamshine05, teamplay04, teamtreasure02
   - schedule sync meeting
   - divide work based on team strengths

**estimated time to first working prototype**: 2 weeks

**estimated time to usable framework**: 12 weeks

**estimated time to production apps**: 16-20 weeks

---

## questions for reflection

let me leave you with some socratic questions. think about these:

1. **does gpui's complexity worry you?** is the learning curve worth the performance gains?

2. **how do you feel about the ffi approach?** should we abstract more or less?

3. **is the ember harvest theme aligned with your vision?** does it capture the "coals glowing in darkness" aesthetic?

4. **are the team assignments right?** does each team's zodiac/tarot energy match their responsibilities?

5. **what's the minimum viable grainui?** what's the smallest version that's still useful?

6. **how do we handle the e-ink challenge?** do we wait for gpu-enabled e-ink, or build cpu fallback now?

7. **is webassembly deployment actually important?** or should we focus 100% on native desktop?

**think on these.** the answers will shape our path forward.

---

## appendix: code examples

### example 1: complete graincard viewer

```steel
;; grainstore/grain12pbc/teamshine05/grainui/examples/graincard-viewer.scm

(require "grainui/core")
(require "grainui/components")
(require "grainui/themes/ember-harvest")

;; load graincards from directory
(define graincards
  (load-graincards-from-dir "~/github/kae3g/teamkae3gtravel12/"))

;; app state
(define app-state
  (atom {:current-page 0
         :cards-per-page 6
         :search-query ""}))

;; filtered cards based on search
(define visible-cards
  (computed app-state
    (lambda (state)
      (let ([query (:search-query state)])
        (if (string-empty? query)
          graincards
          (filter-cards graincards query))))))

;; main app
(define (graincard-viewer-app)
  (window
    #:title "grain network - graincard viewer"
    #:width 1200
    #:height 800
    #:theme ember-harvest
    
    (div
      #:flex-direction "column"
      #:padding 16
      #:gap 16
      
      ;; header
      (div
        #:flex-direction "row"
        #:justify "space-between"
        #:align "center"
        
        (text "graincard viewer 🌾"
          #:size 24
          #:weight "bold"
          #:color (theme-color 'fg-primary))
        
        (text (format "~a cards total"
                      (length graincards))
          #:size 14
          #:color (theme-color 'fg-secondary)))
      
      ;; search bar
      (input
        #:placeholder "search by grainorder, content, or tag..."
        #:value (:search-query @app-state)
        #:on-change
          (lambda (value)
            (swap! app-state assoc :search-query value)))
      
      ;; graincard grid (virtual scrolling!)
      (scroll-view
        #:flex 1
        
        (graincard-grid
          #:cards (visible-cards @app-state)
          #:columns 3
          #:gap 16))
      
      ;; footer with pagination
      (div
        #:flex-direction "row"
        #:justify "center"
        #:gap 8
        
        (button
          #:label "← previous"
          #:disabled? (= (:current-page @app-state) 0)
          #:on-click
            (lambda ()
              (swap! app-state update :current-page dec)))
        
        (text (format "page ~a"
                      (+ (:current-page @app-state) 1))
          #:color (theme-color 'fg-secondary))
        
        (button
          #:label "next →"
          #:on-click
            (lambda ()
              (swap! app-state update :current-page inc)))))))

;; run the app!
(run-app graincard-viewer-app)
```

### example 2: custom component

```steel
;; grainstore/grain12pbc/teamshine05/grainui/components/graincard.scm

(define (graincard-view card)
  (div
    #:class "graincard"
    #:width 400
    #:padding 16
    #:bg (theme-color 'bg-tertiary)
    #:border-radius (theme-space 'border-radius-md)
    #:flex-direction "column"
    #:gap 8
    
    ;; grainorder header
    (div
      #:flex-direction "row"
      #:justify "space-between"
      #:align "center"
      
      (text (graincard-order card)
        #:family (theme-font 'mono)
        #:size 14
        #:color (theme-color 'accent-ember)
        #:weight "bold")
      
      (text (graincard-timestamp card)
        #:size 12
        #:color (theme-color 'fg-tertiary)))
    
    ;; separator line
    (div
      #:height 1
      #:bg (theme-color 'accent-ash)
      #:opacity 0.3)
    
    ;; card content (80×110 monospace)
    (scroll-view
      #:height 330  ; 110 lines × 3px per line
      
      (pre
        #:family (theme-font 'mono)
        #:size 12
        #:color (theme-color 'fg-primary)
        #:line-height 1.5
        #:white-space "pre"
        (graincard-content card)))
    
    ;; metadata footer
    (div
      #:flex-direction "row"
      #:justify "space-between"
      #:align "center"
      
      (text (format "card ~a of 1,235,520"
                    (graincard-number card))
        #:size 12
        #:color (theme-color 'fg-tertiary))
      
      (text "now == next + 1 🌾"
        #:size 12
        #:color (theme-color 'accent-ember)))))
```

---

**grainorder**: `xzvsnm` (head-insert)  
**card**: xzvsnm (1 of 1,235,520)  
**now == next + 1** 🌾

*may your graincards render beautifully, and your uis flow like water...*


