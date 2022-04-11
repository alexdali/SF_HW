Webruntime.define('lwc/contactListItem', ['lwc'], function (lwc) { 'use strict';

    function stylesheet(hostSelector, shadowSelector, nativeShadow) {
      return "@media all and (-ms-high-contrast: none), (-ms-high-contrast: active) {.slds-slot" + shadowSelector + " {display: flex;}\n}";
    }
    var _implicitStylesheets = [stylesheet];

    function tmpl($api, $cmp, $slotset, $ctx) {
      const {
        s: api_slot
      } = $api;
      return [api_slot("", {
        classMap: {
          "slds-slot": true
        },
        key: 0
      }, [], $slotset)];
    }

    var _tmpl = lwc.registerTemplate(tmpl);
    tmpl.slots = [""];
    tmpl.stylesheets = [];

    if (_implicitStylesheets) {
      tmpl.stylesheets.push.apply(tmpl.stylesheets, _implicitStylesheets);
    }
    tmpl.stylesheetTokens = {
      hostAttribute: "lightning-layout_layout-host",
      shadowAttribute: "lightning-layout_layout"
    };

    /**
    A string normalization utility for attributes.
    @param {String} value - The value to normalize.
    @param {Object} config - The optional configuration object.
    @param {String} [config.fallbackValue] - The optional fallback value to use if the given value is not provided or invalid. Defaults to an empty string.
    @param {Array} [config.validValues] - An optional array of valid values. Assumes all input is valid if not provided.
    @return {String} - The normalized value.
    **/
    function normalizeString(value, config = {}) {
      const {
        fallbackValue = '',
        validValues,
        toLowerCase = true
      } = config;
      let normalized = typeof value === 'string' && value.trim() || '';
      normalized = toLowerCase ? normalized.toLowerCase() : normalized;

      if (validValues && validValues.indexOf(normalized) === -1) {
        normalized = fallbackValue;
      }

      return normalized;
    }
    /**
    A boolean normalization utility for attributes.
    @param {Any} value - The value to normalize.
    @return {Boolean} - The normalized value.
    **/

    function normalizeBoolean(value) {
      return typeof value === 'string' || !!value;
    }

    const isIE11 = isIE11Test(navigator);
    const isChrome = isChromeTest(navigator);
    const isSafari = isSafariTest(navigator); // The following functions are for tests only

    function isIE11Test(navigator) {
      // https://stackoverflow.com/questions/17447373/how-can-i-target-only-internet-explorer-11-with-javascript
      return /Trident.*rv[ :]*11\./.test(navigator.userAgent);
    }
    function isChromeTest(navigator) {
      // https://stackoverflow.com/questions/4565112/javascript-how-to-find-out-if-the-user-browser-is-chrome
      return /Chrome/.test(navigator.userAgent) && /Google Inc/.test(navigator.vendor);
    }
    function isSafariTest(navigator) {
      // via https://stackoverflow.com/questions/49872111/detect-safari-and-stop-script
      return /^((?!chrome|android).)*safari/i.test(navigator.userAgent);
    }

    const proto = {
      add(className) {
        if (typeof className === 'string') {
          this[className] = true;
        } else {
          Object.assign(this, className);
        }

        return this;
      },

      invert() {
        Object.keys(this).forEach(key => {
          this[key] = !this[key];
        });
        return this;
      },

      toString() {
        return Object.keys(this).filter(key => this[key]).join(' ');
      }

    };
    function classSet(config) {
      if (typeof config === 'string') {
        const key = config;
        config = {};
        config[key] = true;
      }

      return Object.assign(Object.create(proto), config);
    }

    const HALIN_CLASS = {
      center: 'slds-grid_align-center',
      space: 'slds-grid_align-space',
      spread: 'slds-grid_align-spread',
      end: 'slds-grid_align-end'
    };
    const VALIN_CLASS = {
      start: 'slds-grid_vertical-align-start',
      center: 'slds-grid_vertical-align-center',
      end: 'slds-grid_vertical-align-end',
      stretch: 'slds-grid_vertical-stretch'
    };
    const BOUNDARY_CLASS = {
      small: 'slds-grid_pull-padded',
      medium: 'slds-grid_pull-padded-medium',
      large: 'slds-grid_pull-padded-large'
    };
    const VERTICAL_ALIGN = Object.keys(VALIN_CLASS);
    const BOUNDARY = Object.keys(BOUNDARY_CLASS);
    const HORIZONTAL_ALIGN = Object.keys(HALIN_CLASS);
    const ROWS_CLASS = 'slds-wrap';
    const GRID_CLASS = 'slds-grid';
    function normalizeParam(value, valid, fallback) {
      value = value ? value.toLowerCase() : ' ';
      return normalizeString(value, {
        fallbackValue: fallback || ' ',
        validValues: valid || []
      });
    }
    function computeLayoutClass(hAlign, vAlign, boundary, multiRows) {
      const computedClass = classSet(GRID_CLASS);

      if (hAlign !== ' ' && HALIN_CLASS[hAlign]) {
        computedClass.add(HALIN_CLASS[hAlign]);
      }

      if (vAlign !== ' ' && VALIN_CLASS[vAlign]) {
        computedClass.add(VALIN_CLASS[vAlign]);
      }

      if (boundary !== ' ' && BOUNDARY_CLASS[boundary]) {
        computedClass.add(BOUNDARY_CLASS[boundary]);
      }

      if (multiRows) {
        computedClass.add(ROWS_CLASS);
      }

      return computedClass;
    }

    /**
     * Represents a responsive grid system for arranging containers on a page.
     */

    class LightningLayout extends lwc.LightningElement {
      constructor(...args) {
        super(...args);
        this._horizontalAlign = void 0;
        this._verticalAlign = void 0;
        this._pullToBoundary = void 0;
        this._multipleRows = void 0;
        this._layoutClass = [];
      }

      /**
       * Determines how to spread the layout items horizontally.
       * The alignment options are center, space, spread, and end.
       * @type {string}
       * @default
       */
      get horizontalAlign() {
        return this._horizontalAlign;
      }

      set horizontalAlign(value) {
        this._horizontalAlign = normalizeParam(value, HORIZONTAL_ALIGN);
        this.updateClassList();
      }

      /**
       * Determines how to align the layout items vertically in the container.
       * The alignment options are start, center, end, and stretch.
       * @type {string}
       * @default
       */
      get verticalAlign() {
        return this._verticalAlign;
      }

      set verticalAlign(value) {
        this._verticalAlign = normalizeParam(value, VERTICAL_ALIGN);
        this.updateClassList();
      }

      /**
       * Pulls layout items to the layout boundaries and corresponds
       * to the padding size on the layout item. Possible values are small, medium, or large.
       * @type {string}
       * @default
       *
       */
      get pullToBoundary() {
        return this._pullToBoundary;
      }

      set pullToBoundary(value) {
        this._pullToBoundary = normalizeParam(value, BOUNDARY);
        this.updateClassList();
      }

      /**
       * If present, layout items wrap to the following line when they exceed the layout width.
       * @type {boolean}
       * @default false
       */
      get multipleRows() {
        return this._multipleRows || false;
      }

      set multipleRows(value) {
        this._multipleRows = normalizeBoolean(value);
        this.updateClassList();
      }

      connectedCallback() {
        this.updateClassList();
      }

      updateClassList() {
        this.classList.remove(...this._layoutClass);
        const config = computeLayoutClass(this.horizontalAlign, this.verticalAlign, this.pullToBoundary, this.multipleRows);
        this._layoutClass = Object.keys(config);
        this.classList.add(...this._layoutClass);
      }

    }

    lwc.registerDecorators(LightningLayout, {
      publicProps: {
        horizontalAlign: {
          config: 3
        },
        verticalAlign: {
          config: 3
        },
        pullToBoundary: {
          config: 3
        },
        multipleRows: {
          config: 3
        }
      },
      track: {
        _horizontalAlign: 1,
        _verticalAlign: 1,
        _pullToBoundary: 1,
        _multipleRows: 1
      },
      fields: ["_layoutClass"]
    });

    var _lightningLayout = lwc.registerComponent(LightningLayout, {
      tmpl: _tmpl
    });

    function tmpl$1($api, $cmp, $slotset, $ctx) {
      const {
        s: api_slot
      } = $api;
      return [api_slot("", {
        key: 0
      }, [], $slotset)];
    }

    var _tmpl$1 = lwc.registerTemplate(tmpl$1);
    tmpl$1.slots = [""];
    tmpl$1.stylesheets = [];
    tmpl$1.stylesheetTokens = {
      hostAttribute: "lightning-layoutItem_layoutItem-host",
      shadowAttribute: "lightning-layoutItem_layoutItem"
    };

    const SIZE_MIN = 1;
    const SIZE_MAX = 12;
    const DEFAULT_LAYOUT_SIZE = {
      default: null,
      small: null,
      medium: null,
      large: null
    };
    const PADDING = ['horizontal-small', 'horizontal-medium', 'horizontal-large', 'around-small', 'around-medium', 'around-large'];
    const PADDING_CLASS = {
      'slds-p-right_small': 'horizontal-small',
      'slds-p-left_small': 'horizontal-small',
      'slds-p-right_medium': 'horizontal-medium',
      'slds-p-left_medium': 'horizontal-medium',
      'slds-p-right_large': 'horizontal-large',
      'slds-p-left_large': 'horizontal-large',
      'slds-p-around_small': 'around-small',
      'slds-p-around_medium': 'around-medium',
      'slds-p-around_large': 'around-large'
    };
    const FLEXIBILITY = ['auto', 'shrink', 'no-shrink', 'grow', 'no-grow', 'no-flex'];
    const FLEX_CLASS = {
      'slds-col': 'auto',
      'slds-grow': 'grow',
      'slds-shrink': 'shrink',
      'slds-grow-none': 'no-grow',
      'slds-shrink-none': 'no-shrink',
      'slds-no-flex': 'no-flex'
    };
    const SIZE_CLASS = {
      default: 'slds-size_',
      small: 'slds-small-size_',
      medium: 'slds-medium-size_',
      large: 'slds-large-size_'
    };
    const DIRECTION = ['left', 'top', 'right', 'bottom'];
    const STYLE_ERROR = {
      FLEX_CONFLICT: 'You cannot have `flexibility` value to be set to `auto` and `no-flex` together for <lightning-layout-item> component',
      SIZE_RANGE: 'Invalid `size` attribute for <lightning-layout-item> component. The `size` attribute should be an integer between 1 and 12',
      SMALL_SIZE_RANGE: 'Invalid `smallDeviceSize` attribute for <lightning-layout-item> component. The `smallDeviceSize` attribute should be an integer between 1 and 12',
      MEDIUM_SIZE_RANGE: 'Invalid `mediumDeviceSize` attribute for <lightning-layout-item> component. The `mediumDeviceSize` attribute should be an integer between 1 and 12',
      LARGE_SIZE_RANGE: 'Invalid `largeDeviceSize` attribute for <lightning-layout-item> component. The `largeDeviceSize` attribute should be an integer between 1 and 12',
      SIZE_REQUIRED: 'You cannot have device specific size attributes for <lightning-layout-item> component without specifying the `size` attribute'
    };

    function hasConflict(value) {
      return value.some(item => item === 'auto') && value.some(item => item === 'no-flex');
    }

    function toArray(value) {
      if (Array.isArray(value)) {
        return value;
      } else if (typeof value === 'string') {
        value = value.split(',');
        return value.map(item => item.trim());
      }

      return [value];
    }

    function normalizeDirection(value, fallback) {
      value = value ? value.toLowerCase() : ' ';
      return normalizeString(value, {
        fallbackValue: fallback || '',
        validValues: DIRECTION
      });
    }
    function normalizePadding(value) {
      value = value ? value.toLowerCase() : ' ';
      return normalizeString(value, {
        fallbackValue: ' ',
        validValues: PADDING
      });
    }
    function normalizeFlexibility(value) {
      value = toArray(value);

      if (hasConflict(value)) {
        throw new Error(STYLE_ERROR.FLEX_CONFLICT);
      }

      return value.filter(item => FLEXIBILITY.some(allowed => item === allowed));
    }
    function normalizeSize(value) {
      if (value != null) {
        const size = parseFloat(value);
        return isNaN(size) ? null : Math.round(size);
      }

      return value;
    }

    function computePaddingClass(padding, computedClass) {
      computedClass = computedClass || classSet();
      padding = padding || ' ';
      Object.keys(PADDING_CLASS).forEach(key => {
        if (PADDING_CLASS[key].toLowerCase() === padding) {
          computedClass.add(key);
        }
      });
      return computedClass;
    }

    function computeFlexibilityClass(flexibility, computedClass) {
      computedClass = computedClass || classSet();
      flexibility = flexibility || [];
      Object.keys(FLEX_CLASS).forEach(key => {
        if (flexibility.some(flex => flex === FLEX_CLASS[key])) {
          computedClass.add(key);
        }
      });
      return computedClass;
    }

    function computeSizeClass(layoutSize, computedClass) {
      computedClass = computedClass || classSet();
      layoutSize = layoutSize || DEFAULT_LAYOUT_SIZE;
      Object.keys(SIZE_CLASS).forEach(key => {
        const size = layoutSize[key];

        if (size != null && size !== 0) {
          computedClass.add(`${SIZE_CLASS[key]}${size}-of-12`);
        }
      });
      return computedClass;
    }

    function computeBumpClass(direction, computedClass) {
      computedClass = computedClass || classSet();
      direction = direction || '';

      if (direction !== '') {
        computedClass.add(`slds-col_bump-${direction}`);
      }

      return computedClass;
    }

    function computeLayoutClass$1(layoutSize, flexibility, padding, bump) {
      const computedClass = computePaddingClass(padding);
      computeFlexibilityClass(flexibility, computedClass);
      computeSizeClass(layoutSize, computedClass);
      computeBumpClass(bump, computedClass);
      return computedClass;
    }
    function validateSize(size, smallDeviceSize, mediumDeviceSize, largeDeviceSize) {
      if (size != null && !(SIZE_MIN <= size && size <= SIZE_MAX)) {
        throw new Error(STYLE_ERROR.SIZE_RANGE);
      }

      if (smallDeviceSize != null && !(SIZE_MIN <= smallDeviceSize && smallDeviceSize <= SIZE_MAX)) {
        throw new Error(STYLE_ERROR.SMALL_SIZE_RANGE);
      }

      if (mediumDeviceSize != null && !(SIZE_MIN <= mediumDeviceSize && mediumDeviceSize <= SIZE_MAX)) {
        throw new Error(STYLE_ERROR.MEDIUM_SIZE_RANGE);
      }

      if (largeDeviceSize && !(SIZE_MIN <= largeDeviceSize && largeDeviceSize <= SIZE_MAX)) {
        throw new Error(STYLE_ERROR.LARGE_SIZE_RANGE);
      }

      if (size == null && (smallDeviceSize != null || mediumDeviceSize != null || largeDeviceSize != null)) {
        throw new Error(STYLE_ERROR.SIZE_REQUIRED);
      }

      return true;
    }

    /**
     * The basic element in a lightning-layout component.
     * A layout item groups information together to define visual grids, spacing, and sections.
     * @slot default Placeholder for your content in lightning-layout-item.
     */

    class LightningLayoutItem extends lwc.LightningElement {
      constructor(...args) {
        super(...args);
        this._flexibility = void 0;
        this._alignmentBump = void 0;
        this._padding = void 0;
        this._size = void 0;
        this._smallDeviceSize = void 0;
        this._mediumDeviceSize = void 0;
        this._largeDeviceSize = void 0;
        this._layoutClass = [];
      }

      /**
       * Make the item fluid so that it absorbs any extra space in its
       * container or shrinks when there is less space. Allowed values are:
       * auto (columns grow or shrink equally as space allows),
       * shrink (columns shrink equally as space decreases),
       * no-shrink (columns don't shrink as space reduces),
       * grow (columns grow equally as space increases),
       * no-grow (columns don't grow as space increases),
       * no-flex (columns don't grow or shrink as space changes).
       * Use a comma-separated value for multiple options, such as 'auto, no-shrink'.
       * @type {object}
       */
      get flexibility() {
        return this._flexibility;
      }

      set flexibility(value) {
        this._flexibility = normalizeFlexibility(value);
        this.updateClassList();
      }

      /**
       * Specifies a direction to bump the alignment of adjacent layout items. Allowed values are left, top, right, bottom.
       * @type {string}
       */
      get alignmentBump() {
        return this._alignmentBump;
      }

      set alignmentBump(value) {
        this._alignmentBump = normalizeDirection(value);
        this.updateClassList();
      }

      /**
       * Sets padding to either the right and left sides of a container,
       * or all sides of a container. Allowed values are horizontal-small,
       * horizontal-medium, horizontal-large, around-small, around-medium, around-large.
       * @type {string}
       */
      get padding() {
        return this._padding;
      }

      set padding(value) {
        this._padding = normalizePadding(value);
        this.updateClassList();
      }

      /**
       * If the viewport is divided into 12 parts, size indicates the
       * relative space the container occupies. Size is expressed as
       * an integer from 1 through 12. This applies for all device-types.
       * @type {number}
       */
      get size() {
        return this._size;
      }

      set size(value) {
        this._size = normalizeSize(value);
        this.validateSize();
        this.updateClassList();
      }

      /**
       * If the viewport is divided into 12 parts, this attribute indicates
       * the relative space the container occupies on device-types larger than
       * mobile. It is expressed as an integer from 1 through 12.
       * @type {number}
       */
      get smallDeviceSize() {
        return this._smallDeviceSize;
      }

      set smallDeviceSize(value) {
        this._smallDeviceSize = normalizeSize(value);
        this.validateSize();
        this.updateClassList();
      }

      /**
       * If the viewport is divided into 12 parts, this attribute indicates
       * the relative space the container occupies on device-types larger than
       * tablet. It is expressed as an integer from 1 through 12.
       * @type {number}
       */
      get mediumDeviceSize() {
        return this._mediumDeviceSize;
      }

      set mediumDeviceSize(value) {
        this._mediumDeviceSize = normalizeSize(value);
        this.validateSize();
      }

      /**
       * If the viewport is divided into 12 parts, this attribute indicates
       * the relative space the container occupies on device-types larger than
       * desktop. It is expressed as an integer from 1 through 12.
       * @type {number}
       */
      get largeDeviceSize() {
        return this._largeDeviceSize;
      }

      set largeDeviceSize(value) {
        this._largeDeviceSize = normalizeSize(value);
        this.validateSize();
        this.updateClassList();
      }

      connectedCallback() {
        this.updateClassList();
      }

      updateClassList() {
        this.classList.remove(...this._layoutClass);
        const config = computeLayoutClass$1({
          default: this.size,
          small: this.smallDeviceSize,
          medium: this.mediumDeviceSize,
          large: this.largeDeviceSize
        }, this.flexibility, this.padding, this.alignmentBump);
        this._layoutClass = Object.keys(config);
        this.classList.add(...this._layoutClass);
      }

      validateSize() {
        validateSize(this.size, this.smallDeviceSize, this.mediumDeviceSize, this.largeDeviceSize);
      }

    }

    lwc.registerDecorators(LightningLayoutItem, {
      publicProps: {
        flexibility: {
          config: 3
        },
        alignmentBump: {
          config: 3
        },
        padding: {
          config: 3
        },
        size: {
          config: 3
        },
        smallDeviceSize: {
          config: 3
        },
        mediumDeviceSize: {
          config: 3
        },
        largeDeviceSize: {
          config: 3
        }
      },
      track: {
        _flexibility: 1,
        _alignmentBump: 1,
        _padding: 1,
        _size: 1,
        _smallDeviceSize: 1,
        _mediumDeviceSize: 1,
        _largeDeviceSize: 1
      },
      fields: ["_layoutClass"]
    });

    var _lightningLayoutItem = lwc.registerComponent(LightningLayoutItem, {
      tmpl: _tmpl$1
    });

    function tmpl$2($api, $cmp, $slotset, $ctx) {
      const {
        c: api_custom_element,
        d: api_dynamic,
        h: api_element,
        b: api_bind
      } = $api;
      const {
        _m0
      } = $ctx;
      return [api_element("a", {
        attrs: {
          "href": "#"
        },
        key: 4,
        on: {
          "click": _m0 || ($ctx._m0 = api_bind($cmp.selectHandler))
        }
      }, [api_custom_element("lightning-layout", _lightningLayout, {
        props: {
          "verticalAlign": "center"
        },
        key: 3
      }, [api_custom_element("lightning-layout-item", _lightningLayoutItem, {
        key: 0
      }, []), api_custom_element("lightning-layout-item", _lightningLayoutItem, {
        props: {
          "padding": "around-small"
        },
        key: 2
      }, [api_element("p", {
        key: 1
      }, [api_dynamic($cmp.contact.Name)])])])])];
    }

    var _tmpl$2 = lwc.registerTemplate(tmpl$2);
    tmpl$2.stylesheets = [];
    tmpl$2.stylesheetTokens = {
      hostAttribute: "lwc-contactListItem_contactListItem-host",
      shadowAttribute: "lwc-contactListItem_contactListItem"
    };

    class ContactListItem extends lwc.LightningElement {
      constructor(...args) {
        super(...args);
        this.contact = void 0;
      }

      selectHandler(event) {
        // Prevents the anchor element from navigating to a URL.
        event.preventDefault(); // Creates the event with the contact ID data.

        const selectedEvent = new CustomEvent('selected', {
          detail: this.contact.Id
        }); // Dispatches the event.

        this.dispatchEvent(selectedEvent);
      }

    }

    lwc.registerDecorators(ContactListItem, {
      publicProps: {
        contact: {
          config: 0
        }
      }
    });

    var contactListItem = lwc.registerComponent(ContactListItem, {
      tmpl: _tmpl$2
    });

    return contactListItem;

});
