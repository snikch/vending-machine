# Vending Machine

Access your [Vend Store](http://vendhq.com) in Ruby! Vending Machine turns the [Vend API](http://docs.vendhq.com/) into Ruby objects, including type coercion and nested objects.

```ruby
# Create an instance of your store
store = Vend::Store.new('store_name', 'user_name', 'password')

# Get all your products
store.products.order('name', 'ASC').map &:name
=> ["Coffee (Demo)", "Discount", "T-shirt (Demo)", "test"]

# Type coercion
store.sales.first.total_price.class
=> Float

# Nested objects
store.sales.first.register_sale_products.first.class
=> Vend::RegisterSaleProduct
```

## Installation

Add this line to your application's Gemfile:

    gem 'vending-machine'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vending-machine

## Usage

### Get a store instance

All usage revolves around your store, as per Vend itself


```ruby
store = Vend::Store.new('store_name', 'user_name', 'password')
```

Once you have a store instance you can retrieve your objects

### Customers

```ruby
customers = store.customers
customers.first.customer_code
=> "WALKIN"
```

### Payment Types

```ruby
types = store.payment_types
types.first.name
=> "Cash"
```

### Products

```ruby
store.products.map &:name
=> ["Coffee (Demo)", "T-shirt (Demo)", "Discount", "test"]
```

#### Scopes
Scopes available: `active`, `order_by`, `order_direction` and an `order` shortcut to do both order by and direction at once. Scopes are chainable.

```ruby
store.products.active.map &:name
=> ["T-shirt (Demo)", "Discount", "test"]

store.products.order_by('name').map &:name
=> ["Coffee (Demo)", "Discount", "T-shirt (Demo)", "test"]

store.products.order_by('name').order_direction('desc').map &:name
=> ["test", "T-shirt (Demo)", "Discount", "Coffee (Demo)"]

store.products.order('name', 'DESC').map &:name
=> ["test", "T-shirt (Demo)", "Discount", "Coffee (Demo)"]
```

#### Creating a Product

Initialize a new product with `#build`, `#create` or `#create!`.

* `build` create an unsaved instance
* `create` create an instance, and call `#save`
* `create!` create an instance, and call `#save!`


```ruby
product = store.products.build name: "Product Name", handle: "prod1", retail_price: 25

# Safe save
product.save
=> false

product.error
=> ["Could not Add or Update: Missing sku"]

# Explosive save
product.save!
=> Vend::ValidationFailed: Could not Add or Update: Missing sku

product.sku = 'prod1'
product.save!
=> true
```

#### Creating a Product Variant

Product variants have the same `handle` as another product, but a different `sku`. You can create a variant of a product easily with the `#build_variant`, `#create_variant` and `#create_variant!` methods.

Underneath the hood, it's simply copying attributes to a new instance, then changing the `sku` to either a provided new sku, or appending an incrementing integer to existing `sku`.

```ruby
product.sku = 'my-product'
product.build_variant(sku: 'my-product-alt')
=> <#Vend::Product>

product.build_variant(sku: 'my-product-alt').sku
=> 'my-product-alt'

product.build_variant.sku
=> 'my-product-1'

product.sku = 'my-product-3'
product.build_variant.sku
=> 'my-product-4'
```

### Register Sales

```ruby
sales = store.sales

sales.map{|sale| sale.total_price + sale.total_tax }
=> [1337.0, 1341.95]

sales.first.products.map &:name
=> ["T-shirt (Demo)", "Coffee (Demo)"]

sales.first.products.first
=> "#<Vend::RegisterSaleProduct:0x007fe238720d68>"
```

### Registers

```ruby
store.registers.map &:name
=> ["Main Register", "Back office Register"]
```

### Suppliers

```ruby
store.suppliers.map &:name
=> ["Mal Curtis", "Vend"]
```

### Taxes

```ruby
store.taxes.map &:name
=> ["NZ GST", "AU GST", "Asshole Tax"]
```

The `default` scope will provide you the first returned default tax (note, this still retrieves all taxes from the API).

```ruby
store.taxes.default.name
=> "NZ GST"
```

### Users

```ruby
store.users.map &:name
=> ["A cashier", "Mal Curtis", "Joe Bloggs"]
```

## Status
* COMPLETE: GET index resources are implemented, with the exception of Stock Control
* IN PROGRESS: find  singular resources `store.products.find('some_id')`
* IN PROGRESS: create register sales `store.sale.create products: [product1, product2]`
* COMPLETE: create products
* IN PROGRESS: Create Product Variants (This seems to happen when posting a new product with a same handle, but different sku)
* TODO: Delete resources
* TODO: Scopes for Customer and Register Sales

## Created By

* [Mal Curtis](https://github.com/snikch). Twitter: [snikchnz](https://twitter.com/snikchnz)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
