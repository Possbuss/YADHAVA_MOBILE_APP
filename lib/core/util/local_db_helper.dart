import 'package:Yadhava/features/auth/data/route_model.dart';
import 'package:Yadhava/features/customer/data/client_model.dart';
import 'package:Yadhava/features/customer/model/InvoiceModel.dart';
import 'package:Yadhava/features/customer/model/cash_receipt_model.dart';
import 'package:Yadhava/features/customer/presentation/pages/customer_details/model/product_master.dart';
import 'package:Yadhava/features/home/data/totalSales_model.dart';
import 'package:Yadhava/features/route/model/route_history_model.dart';
import 'package:Yadhava/features/route/presentation/pages/route_details/route_details.dart';
import 'package:Yadhava/features/splash/data/getall_company_model.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/customer/data/client_active_inactive_model.dart';
import '../../features/customer/model/last_invoice_model.dart';
import '../../features/customer/model/mobile_app_sales_Invoice_all.dart';
import '../../features/customer/presentation/pages/customer_details/model/order_model.dart';
import '../../features/home/data/cash_credit_details.dart';
import '../../features/home/data/cash_summery.dart';
import '../../features/home/data/credit_summery.dart';
import '../../features/home/data/sales_summery.dart';
import '../../features/home/data/stockStsModel.dart';
import '../../features/route/model/route_detailsModel.dart';
import 'package:uuid/uuid.dart';

class LocalDbHelper {

  final _uuid = const Uuid();
  static final LocalDbHelper _instance = LocalDbHelper._internal();
  factory LocalDbHelper() => _instance;
  LocalDbHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'clients.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE company_master (
            companyId INTEGER PRIMARY KEY,
            companyName TEXT,
            taxRegistrationNo TEXT,
            address TEXT,
            street TEXT,
            city TEXT,
            country TEXT,
            stateProvince TEXT,
            pincode TEXT,
            phone TEXT,
            mobile TEXT,
            fax TEXT,
            zoneNumber TEXT,
            crNo TEXT,
            buildingNumber TEXT,
            isActive TEXT,
            emailid TEXT,
            companyCode TEXT,
            companyLogo TEXT,
            companyType TEXT,
            fssai TEXT,
            bankAccountName TEXT,
            bankAccountNumber TEXT,
            bankIfscCode TEXT,
            bankBranch TEXT,
            isTaxEnabled TEXT,
            dbBackupPath TEXT,
            upiId TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS clients_active_inactive (
            clientId INTEGER PRIMARY KEY,            
            clientName TEXT,
            routeId INTEGER,
            invoiceDate TEXT,
            clientType TEXT
            )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS clients (
            id INTEGER PRIMARY KEY,
            companyId INTEGER,
            name TEXT,
            contactPersonName TEXT,
            routeId INTEGER,
            routeName TEXT,
            amount REAL,
            mobile TEXT,
            salesmanId INTEGER,
            salesmanName TEXT,
            latitude REAL,
            longitude REAL,
            transactionYear INTEGER,
            clientSortOrder INTEGER,
            isActive TEXT,
            createdDate TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS sales_transactions (
            branchId INTEGER,
            branchName TEXT,
            routeId INTEGER,
            routeName TEXT,
            amount REAL,
            payType TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS product_stocks (
            productId INTEGER,
            partNumber TEXT,
            productName TEXT,
            packingId INTEGER,
            packingName TEXT,
            companyId INTEGER,
            sellingPrice REAL,
            stock REAL,
            stockValue REAL,
            srtQty REAL
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS sales_summary (
            invoiceNo TEXT,
            invoiceDate TEXT,
            customerAccountId INTEGER,
            customerAccountName TEXT,
            totalAmount REAL,
            discountAmount REAL,
            netTotal REAL
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS credit_summary (
            customerAccountName TEXT,
            amount REAL
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS cash_summary (
            customerAccountName TEXT,
            payType TEXT,
            amount REAL
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS cash_credit_details (
            customerId INTEGER,
            customerName TEXT,
            debit REAL,
            credit REAL
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS mobile_app_sales_invoice_master (
              invoiceId INTEGER PRIMARY KEY,
              companyId INTEGER,
              routeId INTEGER,
              branchId INTEGER,
              branchName TEXT,
              invoiceNo TEXT,
              invoiceDate TEXT,
              salesManId INTEGER,
              salesManName TEXT,
              clientId INTEGER,
              clientName TEXT,
              mobile TEXT,
              totalAmount REAL,
              totalDiscountVal REAL,
              totalTaxableAmount REAL,
              totalSgstAmount REAL,
              totalCgstAmount REAL,
              totalCessAmount REAL,
              totalIgstAmount REAL,
              netTotal REAL,
              payType TEXT,
              latitude TEXT,
              longitude TEXT,
              srtVoucherNo TEXT,
              receiptNo TEXT,
              paidAmount REAL,
              uuid TEXT
           )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS mobile_app_sales_invoice_master_dt (
            invoiceId INTEGER,
            companyId INTEGER,
            routeId INTEGER,
            branchId INTEGER,
            branchName TEXT,
            invoiceNo TEXT,
            invoiceDate TEXT,
            salesManId INTEGER,
            salesManName TEXT,
            clientId INTEGER,
            clientName TEXT,
            mobile TEXT,
            siNo INTEGER,
            productId INTEGER,
            partNumber TEXT,
            productName TEXT,
            packingId INTEGER,
            packingName TEXT,
            packQty INTEGER,
            packingOrder INTEGER,
            packMultiplyQty INTEGER,
            quantity REAL,
            foc REAL,
            srtQty REAL,
            totalQty REAL,
            unitRate REAL,
            totalRate REAL,
            netRate REAL
          )
        ''');

        await db.execute('''
         CREATE TABLE IF NOT EXISTS cash_receipt (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            companyId INTEGER NOT NULL,
            customerId INTEGER NOT NULL,
            customerName TEXT NOT NULL,
            voucherNo TEXT NOT NULL,
            voucherDate TEXT NOT NULL, -- Use TEXT to store date in 'yyyy-MM-dd' format
            payMode TEXT NOT NULL,
            voucherType TEXT NOT NULL,
            paidAmount REAL NOT NULL,
            transactionYear INTEGER NOT NULL,
            userId INTEGER NOT NULL,
            vehicleId INTEGER NOT NULL,
            routeId INTEGER NOT NULL,
            driverId INTEGER NOT NULL
          )
        ''');

        await db.execute('''
        CREATE TABLE IF NOT EXISTS route_history (
          routeDate TEXT NOT NULL,
          routeDay TEXT NOT NULL,
          salesManId INTEGER NOT NULL,
          salesManName TEXT NOT NULL,
          routeId INTEGER NOT NULL,
          routeName TEXT NOT NULL,
          vehicleId INTEGER NOT NULL,
          vehicleName TEXT NOT NULL,
          companyId INTEGER
         )
      ''');

        await db.execute('''
        CREATE TABLE IF NOT EXISTS route_history_details (
          sortOrder INTEGER NOT NULL,
          routeDate TEXT NOT NULL,
          routeDay TEXT NOT NULL,
          customerId INTEGER NOT NULL,
          customerName TEXT NOT NULL,
          contactPersonName TEXT NOT NULL,
          salesManId INTEGER NOT NULL,
          companyId INTEGER,
          routeId INTEGER NOT NULL,          
          longitude REAL,
          latitude REAL
        )
        ''');

        await db.execute('''
           CREATE TABLE IF NOT EXISTS last_invoice_details (
            siNo INTEGER NOT NULL,
            productId INTEGER NOT NULL,
            companyId INTEGER NOT NULL,
            clientId INTEGER NOT NULL,
            partNumber TEXT,
            productName TEXT,
            packingDescription TEXT,
            packingId INTEGER NOT NULL,
            packingName TEXT,
            quantity REAL,
            foc REAL,
            totalQty REAL,
            srtQty REAL,
            unitRate REAL,
            totalRate REAL
          )
        ''');

        await db.execute('''
           CREATE TABLE IF NOT EXISTS product_list (
              companyId INTEGER,
              productId INTEGER PRIMARY KEY,
              partNumber TEXT,
              productName TEXT,
              basePackingId INTEGER,
              isActive TEXT,
              categoryId INTEGER,
              categoryName TEXT,
              packingId INTEGER,
              packingName TEXT,
              packingOrder INTEGER,
              packMultiplyQty INTEGER,
              packingDescription TEXT,
              mrp REAL,
              buyyingPrice REAL,
              sellingPrice REAL,
              wholeSalePrice REAL,              
              srt INTEGER,
              quantity INTEGER,
              foc INTEGER,
              totalRate REAL,
              siNo REAL
            )
        ''');

        await db.execute('''
            CREATE TABLE orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            uuid TEXT UNIQUE NOT NULL,
            company_id INTEGER,
            invoice_id INTEGER,
            client_id INTEGER,
            client_name TEXT,
            driver_id INTEGER,
            driver_name TEXT,
            pay_type TEXT,
            invoice_no TEXT,
            invoice_date TEXT,
            route_id INTEGER,
            vehicle_id INTEGER,
            vehicle_no TEXT,
            total REAL,
            discount_percentage REAL,
            discount_amount REAL,
            net_total REAL,
            transaction_year INTEGER,
            latitude REAL,
            longitude REAL,
            paid_amount REAL,
            status TEXT DEFAULT 'pending'  -- 'pending', 'synced', 'failed'
            );
        ''');

        await db.execute('''
            CREATE TABLE order_details (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            order_id INTEGER,  -- Foreign key to orders.id
            si_no INTEGER,
            product_id INTEGER,
            part_number TEXT,
            product_name TEXT,
            packing_description TEXT,
            packing_id INTEGER,
            packing_name TEXT,
            quantity INTEGER,
            foc INTEGER,
            srt_qty INTEGER,
            total_qty INTEGER,
            unit_rate REAL,
            total_rate REAL,
          
            FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
          );
        ''');
      },
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  // ------------------------------
  // INSERT INVOICE ORDER
  // ------------------------------

  Future<bool> clearPendingOrdersData() async {
    final db = await database;
    await db.delete('order_details');
    await db.delete('orders');
    return true;
  }


  Future<int> insertOrder(OrderModel order) async {
    final db = await database;

    final String orderUuid = _uuid.v4();
    // Insert into orders table
    int orderId = await db.insert('orders', {
      'uuid': orderUuid,
      'company_id': order.companyId,
      'invoice_id': order.invoiceId,
      'client_id': order.clientId,
      'client_name': order.clientName,
      'driver_id': order.driverId,
      'driver_name': order.driverName,
      'pay_type': order.payType,
      'invoice_no': order.invoiceNo,
      'invoice_date': order.invoiceDate,
      'route_id': order.routeId,
      'vehicle_id': order.vehicleId,
      'vehicle_no': order.vehicleNo,
      'total': order.total,
      'discount_percentage': order.discountPercentage,
      'discount_amount': order.discountAmount,
      'net_total': order.netTotal,
      'transaction_year': order.transactionYear,
      'latitude': order.latitude,
      'longitude': order.longitude,
      'paid_amount': order.paidAmount,
    });

    // Insert products
    for (var product in order.mobileAppSalesInvoiceDetails) {
      await db.insert('order_details', {
        'order_id': orderId,
        'si_no': product.siNo,
        'product_id': product.productId,
        'part_number': product.partNumber,
        'product_name': product.productName,
        'packing_description': product.packingDescription,
        'packing_id': product.packingId,
        'packing_name': product.packingName,
        'quantity': product.quantity,
        'foc': product.foc,
        'srt_qty': product.srtQty,
        'total_qty': product.totalQty,
        'unit_rate': product.unitRate,
        'total_rate': product.totalRate,
      });
    }

    return orderId;
  }

  Future<void> markOrderAsSynced(int id) async {
    final db = await database;
    await db.update(
      'orders',
      {'status': 'synced'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> markOrderAsSyncedUuid(int uuid) async {
    final db = await database;
    await db.update(
      'orders',
      {'status': 'synced'},
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
  }

  Future<List<OrderModel>> getPendingOrders([int orderId = 0]) async {
    final db = await database;

    String whereString = 'status = ?';
    List<dynamic> whereArgs = ['pending'];

    if (orderId > 0) {
      whereString += ' AND id = ?';
      whereArgs.add(orderId);
    }

    // Step 1: Fetch all pending orders
    final List<Map<String, dynamic>> orderRows = await db.query(
      'orders',
      where: whereString,
      whereArgs: whereArgs,
    );

    List<OrderModel> orders = [];

    for (final orderRow in orderRows) {
      final int orderId = orderRow['id'];

      // Step 2: Fetch related order details (products) for this order
      final List<Map<String, dynamic>> detailRows = await db.query(
        'order_details',
        where: 'order_id = ?',
        whereArgs: [orderId],
      );

      // Step 3: Convert each detail row to Product
      final products = detailRows
          .map((item) => Product(
                orderId: item['order_id'],
                siNo: item['si_no'],
                productId: item['product_id'],
                partNumber: item['part_number'],
                productName: item['product_name'],
                packingDescription: item['packing_description'],
                packingId: item['packing_id'],
                packingName: item['packing_name'],
                quantity: item['quantity'],
                foc: item['foc'],
                srtQty: item['srt_qty'],
                totalQty: item['total_qty'],
                unitRate: (item['unit_rate'] as num).toDouble(),
                totalRate: (item['total_rate'] as num).toDouble(),
              ))
          .toList();

      // Step 4: Create OrderModel with its products
      final order = OrderModel(
        id: orderRow['id'],
        uuid: orderRow['uuid'],
        companyId: orderRow['company_id'],
        invoiceId: orderRow['invoice_id'],
        clientId: orderRow['client_id'],
        clientName: orderRow['client_name'],
        driverId: orderRow['driver_id'],
        driverName: orderRow['driver_name'],
        payType: orderRow['pay_type'],
        invoiceNo: orderRow['invoice_no'],
        invoiceDate: orderRow['invoice_date'],
        routeId: orderRow['route_id'],
        vehicleId: orderRow['vehicle_id'],
        vehicleNo: orderRow['vehicle_no'],
        total: (orderRow['total'] as num).toDouble(),
        discountPercentage: (orderRow['discount_percentage'] as num).toDouble(),
        discountAmount: orderRow['discount_amount'],
        netTotal: (orderRow['net_total'] as num).toDouble(),
        transactionYear: orderRow['transaction_year'],
        latitude: (orderRow['latitude'] as num).toDouble(),
        longitude: (orderRow['longitude'] as num).toDouble(),
        paidAmount: (orderRow['paid_amount'] as num).toDouble(),
        mobileAppSalesInvoiceDetails: products,
      );

      orders.add(order);
    }

    return orders;
  }

  // -------------------------------
  // Product Master
  // -------------------------------
  Future<void> refreshProductList(List<ProductMaster> products) async {
    final db = await database;

    // Clear existing product data
    await db.delete('product_list');

    // Insert new data
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var product in products) {
        batch.insert('product_list', product.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });

    // Save refresh time
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'lastProductRefresh', DateTime.now().toIso8601String());
  }

  Future<bool> shouldRefreshProductList() async {
    final prefs = await SharedPreferences.getInstance();
    final lastRefresh = prefs.getString('lastProductRefresh');

    if (lastRefresh == null) return true;

    final lastRefreshDate = DateTime.parse(lastRefresh);
    final now = DateTime.now();

    // Check if it's a different day
    return now.difference(lastRefreshDate).inDays >= 1;
  }

  Future<List<ProductMaster>> getProductMaster(int companyId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .query('product_list', where: 'companyId = ?', whereArgs: [companyId]);
    return List.generate(maps.length, (i) {
      return ProductMaster.fromJson(maps[i]);
    });
  }

  // -------------------------------
  // Last Invoice Data
  // -------------------------------
  Future<bool> clearLastInvoiceData(int partyId, int companyId) async {
    final db = await database;
    await db.delete('last_invoice_details',
        where: 'clientId = ? AND companyId = ?',
        whereArgs: [partyId, companyId]);
    return true;
  }

  Future<bool> clearLastInvoiceDataAll() async {
    final db = await database;
    await db.delete('last_invoice_details');
    return true;
  }

  Future<bool> isEmptyLastInvoiceData(int partyId, int companyId) async {
    final db = await database;
    if (partyId == 0) {
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM last_invoice_details WHERE companyId = ?',
        [companyId],
      );
      int count = Sqflite.firstIntValue(result) ?? 0;
      return count == 0;
    } else {
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM last_invoice_details WHERE  clientId = ? and companyId = ?',
        [partyId, companyId],
      );
      int count = Sqflite.firstIntValue(result) ?? 0;
      return count == 0;
    }
  }

  Future<void> insertLastInvoiceData(
      List<MobileAppSalesInvoiceDetail> lastInvoiceDetail) async {
    final db = await database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final invoice in lastInvoiceDetail) {
        batch.insert(
          'last_invoice_details',
          invoice.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true); // set noResult to true for speed
    });
  }

  Future<void> updateLastInvoiceData(
      List<MobileAppSalesInvoiceDetail>? lastInvoiceDetail,
      int partyId,
      int companyId) async {
    await clearLastInvoiceData(partyId, companyId);
    if (lastInvoiceDetail != null) {
      await insertLastInvoiceData(lastInvoiceDetail);
    }
  }

  Future<List<MobileAppSalesInvoiceDetail>> getLastInvoiceData(
      int partyId, int companyId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        'last_invoice_details',
        where: 'clientId = ? AND companyId = ?',
        whereArgs: [partyId, companyId]);
    return List.generate(maps.length, (i) {
      return MobileAppSalesInvoiceDetail.fromJson(maps[i]);
    });
  }

  // -------------------------------
  // Route History
  // -------------------------------
  Future<bool> clearRouteHistoryAll(int routeId, int companyId) async {
    final db = await database;
    await db.delete('route_history',
        where: 'routeId = ? AND companyId = ?',
        whereArgs: [routeId, companyId]);
    return true;
  }

  Future<bool> clearRouteHistoryAllData() async {
    final db = await database;
    await db.delete('route_history');
    return true;
  }

  Future<bool> clearRouteHistoryOn(
      String routeDate, int routeId, int companyId) async {
    final db = await database;
    await db.delete(
      'route_history',
      where: 'routeDate = ? AND routeId = ? AND companyId = ?',
      whereArgs: [routeDate, routeId, companyId],
    );
    return true;
  }

  Future<bool> isEmptyRouteHistory(int? routeId, int? companyId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM route_history WHERE  routeId = ? and companyId = ?',
      [routeId, companyId],
    );
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count == 0;
  }

  Future<void> insertRouteHistory(List<RouteHistory> routes) async {
    final db = await database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final route in routes) {
        batch.insert(
          'route_history',
          route.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true); // set noResult to true for speed
    });
  }

  Future<void> updateRouteHistory(
      List<RouteHistory>? routes, int routeId, int companyId) async {
    await clearRouteHistoryAll(routeId, companyId);
    await insertRouteHistory(routes!);
  }

  Future<List<RouteHistory>> getRouteHistory(int routeId, int companyId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('route_history',
        where: 'routeId = ? AND companyId = ?',
        whereArgs: [routeId, companyId]);
    return List.generate(maps.length, (i) {
      return RouteHistory.fromJson(maps[i]);
    });
  }

  // -------------------------------
  // Route History Details
  // -------------------------------
  Future<bool> clearRouteHistoryDetailsAll(int routeId, int companyId) async {
    final db = await database;
    await db.delete('route_history_details',
        where: 'routeId = ? AND companyId = ?',
        whereArgs: [routeId, companyId]);
    return true;
  }

  Future<bool> clearRouteHistoryDetailsOn(
      String routeDate, int routeId, int companyId) async {
    final db = await database;
    await db.delete(
      'route_history_details',
      where: 'routeDate = ? AND routeId = ? AND companyId = ?',
      whereArgs: [routeDate, routeId, companyId],
    );
    return true;
  }

  Future<bool> isEmptyRouteHistoryDetails(
      int salesManId, int routeId, int companyId, String routeDate) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM route_history_details WHERE salesManId = ? and routeId = ? and companyId = ? and routeDate = ?',
      [salesManId, routeId, companyId, routeDate],
    );
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count == 0;
  }

  Future<void> insertRouteHistoryDetails(
      List<RouteDetailsModel> routeDetails) async {
    final db = await database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final routeDetail in routeDetails) {
        batch.insert(
          'route_history_details',
          routeDetail.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true); // set noResult to true for speed
    });
  }

  Future<void> updateRouteHistoryDetails(List<RouteDetailsModel>? routes,
      String routeDate, int routeId, int companyId) async {
    await clearRouteHistoryDetailsOn(routeDate, routeId, companyId);
    await insertRouteHistoryDetails(routes!);
  }

  Future<List<RouteDetailsModel>> getRouteHistoryDetails(
      String routeDate, int routeId, int salesManId, int companyId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        'route_history_details',
        where: 'routeDate = ? AND routeId = ? AND companyId = ?',
        whereArgs: [routeDate, routeId, companyId]);
    return List.generate(maps.length, (i) {
      return RouteDetailsModel.fromJson(maps[i]);
    });
  }

  // -------------------------------
  // Company Master
  // -------------------------------
  Future<bool> clearCompanyDetails() async {
    final db = await database;
    await db.delete('company_master');
    return true;
  }

  Future<bool> isEmptyCompany() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT COUNT(*) as count FROM company_master');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count == 0;
  }

  Future<void> insertCompany(List<GetAllCompanyModel> companies) async {
    final db = await database;
    await db.transaction((txn) async {
      for (final company in companies) {
        await txn.insert(
          'company_master',
          company.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<List<GetAllCompanyModel>> getAllCompany() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('company_master');

    return List.generate(maps.length, (i) {
      return GetAllCompanyModel.fromJson(maps[i]);
    });
  }

  // -------------------------------
  // Receipts & Payment
  // -------------------------------

  Future<bool> clearReceiptsPayments(int partyId) async {
    final db = await database;
    await db
        .delete('cash_receipt', where: 'customerId = ?', whereArgs: [partyId]);
    return true;
  }

  Future<bool> clearReceiptsPaymentsAll() async {
    final db = await database;
    await db.delete('cash_receipt');
    return true;
  }

  Future<void> insertReceipts(List<CashReceiptModel> receipts) async {
    final db = await database;
    await db.transaction((txn) async {
      for (final receipt in receipts) {
        await txn.insert(
          'cash_receipt',
          receipt.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<List<CashReceiptModel>> getCashReceipts(int partyId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .query('cash_receipt', where: 'customerId = ?', whereArgs: [partyId]);

    return List.generate(maps.length, (i) {
      return CashReceiptModel.fromJson(maps[i]);
    });
  }

  Future<bool> isEmptyReceipts(int customerId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM cash_receipt WHERE customerId = ?',
      [customerId],
    );
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count == 0;
  }

  // -------------------------------
  // Invoice
  // -------------------------------

  Future<bool> clearAllInvoiceTables() async {
    final db = await database;
    await db.delete('mobile_app_sales_invoice_master_dt');
    await db.delete('mobile_app_sales_invoice_master');
    return true;
  }

  Future<bool> clearInvoiceTablesByInvoiceNo(
      String invoiceNo, int companyId) async {
    final db = await database;
    await db.delete('mobile_app_sales_invoice_master_dt',
        where: 'invoiceNo = ? AND companyId = ?',
        whereArgs: [invoiceNo, companyId]);

    await db.delete('mobile_app_sales_invoice_master',
        where: 'invoiceNo = ? AND companyId = ?',
        whereArgs: [invoiceNo, companyId]);

    return true;
  }

  Future<bool> clearInvoiceTablesAll(int companyId) async {
    final db = await database;
    await db.delete('mobile_app_sales_invoice_master_dt',
        where: 'companyId = ?', whereArgs: [companyId]);

    await db.delete(
      'mobile_app_sales_invoice_master',
      where: 'companyId = ?',
      whereArgs: [companyId],
    );

    return true;
  }

  Future<bool> clearInvoiceTablesAllData() async {
    final db = await database;
    await db.delete('mobile_app_sales_invoice_master_dt');

    await db.delete(
      'mobile_app_sales_invoice_master');

    return true;
  }

  Future<bool> clearInvoiceTables(int partyId, int companyId) async {
    final db = await database;
    await db.delete('mobile_app_sales_invoice_master_dt',
        where: 'clientId = ? AND companyId = ?',
        whereArgs: [partyId, companyId]);

    await db.delete(
      'mobile_app_sales_invoice_master',
      where: 'clientId = ? AND companyId = ?',
      whereArgs: [partyId, companyId],
    );

    return true;
  }

  Future<bool> isEmptyInvoice(int? partyId, int? companyId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM mobile_app_sales_invoice_master WHERE  clientId = ? and companyId = ?',
      [partyId, companyId],
    );
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count == 0;
  }

  Future<void> updateInvoices(
      List<MobileAppSalesInvoiceMaster>? invoices,
      List<MobileAppSalesInvoiceMasterDt>? invoicesDt,
      int? clientId,
      int companyId) async {
    final db = await database;

    await db.transaction((txn) async {
      final batch = txn.batch();

      if (clientId != null) {
        batch.delete(
          'mobile_app_sales_invoice_master_dt',
          where: 'clientId = ? AND companyId = ?',
          whereArgs: [clientId, companyId],
        );
      }

      if (clientId != null) {
        batch.delete(
          'mobile_app_sales_invoice_master',
          where: 'clientId = ? AND companyId = ?',
          whereArgs: [clientId, companyId],
        );
      }

      for (final invoice in invoices ?? []) {
        batch.insert(
          'mobile_app_sales_invoice_master',
          invoice.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      for (final invoice in invoicesDt ?? []) {
        batch.insert(
          'mobile_app_sales_invoice_master_dt',
          invoice.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  Future<void> updateInvoicesById(
      List<MobileAppSalesInvoiceMaster>? invoices,
      List<MobileAppSalesInvoiceMasterDt>? invoicesDt,
      int? invoiceId,
      int? clientId,
      int companyId) async {
    final db = await database;

    await db.transaction((txn) async {
      final batch = txn.batch();

      if (clientId != null) {
        batch.delete(
          'mobile_app_sales_invoice_master_dt',
          where: 'clientId = ? AND companyId = ? AND invoiceId = ?',
          whereArgs: [clientId, companyId],
        );
      }

      if (clientId != null) {
        batch.delete(
          'mobile_app_sales_invoice_master',
          where: 'clientId = ? AND companyId = ? AND invoiceId = ?',
          whereArgs: [clientId, companyId],
        );
      }

      for (final invoice in invoices ?? []) {
        batch.insert(
          'mobile_app_sales_invoice_master',
          invoice.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      for (final invoice in invoicesDt ?? []) {
        batch.insert(
          'mobile_app_sales_invoice_master_dt',
          invoice.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  Future<void> insertInvoices(List<MobileAppSalesInvoiceMaster>? invoices,
      List<MobileAppSalesInvoiceMasterDt>? invoicesDt) async {



    final db = await database;
    await db.transaction((txn) async {
      final batch = txn.batch();


      for (final invoice in invoices ?? []) {

        batch.delete(
          'mobile_app_sales_invoice_master_dt',
          where: 'companyId = ? AND invoiceId = ?',
          whereArgs: [invoice.companyId, invoice.invoiceId],
        );

        batch.delete(
          'mobile_app_sales_invoice_master_dt',
          where: 'companyId = ? AND invoiceId = ?',
          whereArgs: [invoice.companyId, invoice.invoiceId],
        );

        batch.insert(
          'mobile_app_sales_invoice_master',
          invoice.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      for (final invoice in invoicesDt ?? []) {

        batch.insert(
          'mobile_app_sales_invoice_master_dt',
          invoice.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  Future<List<MobileAppSalesInvoiceMaster>> getAllInvoices(
      int partyId, int vehicleId, int companyId) async {
    List<MobileAppSalesInvoiceMaster> invoices = [];
    final db = await database;

    if (vehicleId == 0) {
      final List<Map<String, dynamic>> invoiceRows = await db.query(
          'mobile_app_sales_invoice_master',
          where: 'clientId = ? AND companyId = ?',
          whereArgs: [partyId, companyId],
        orderBy: 'invoiceId DESC'
      );

      for (var row in invoiceRows) {
        final detailRows = await db.query(
          'mobile_app_sales_invoice_master_dt',
          where: 'invoiceId = ?',
          whereArgs: [row['invoiceId']],
        );

        MobileAppSalesInvoiceMaster? mobileInvoice;

        if (detailRows.isNotEmpty) {
          // final s = subInvoiceRows.first;

          final details = detailRows
              .map((d) => MobileAppSalesInvoiceMasterDt(
                    siNo: d['siNo'] as int,
                    productId: d['productId'] as int,
                    companyId: d['companyId'] as int,
                    clientId: d['clientId'] as int,
                    partNumber: d['partNumber']?.toString() ?? '',
                    productName: d['productName']?.toString() ?? '',
                    packingId: d['packingId'] as int,
                    packingName: d['packingName']?.toString() ?? '',
                    quantity: (d['quantity'] as num).toDouble(),
                    foc: (d['foc'] as num).toDouble(),
                    srtQty: (d['srtQty'] as num).toDouble(),
                    totalQty: (d['totalQty'] as num).toDouble(),
                    unitRate: (d['unitRate'] as num).toDouble(),
                    totalRate: (d['totalRate'] as num).toDouble(),
                    mobile: row['mobile']?.toString() ?? '',
                    salesManName: row['salesManName']?.toString() ?? '',
                    routeId: d['routeId'] as int,
                    packQty: d['packQty'] as int,
                    netRate: (d['netRate'] as num).toDouble(),
                    invoiceNo: row['invoiceNo']?.toString() ?? '',
                    invoiceId: d['invoiceId'] as int,
                    invoiceDate: d['invoiceDate']?.toString() ?? '',
                    clientName: d['clientName']?.toString() ?? '',
                    branchName: d['branchName']?.toString() ?? '',
                    branchId: d['branchId'] as int,
                    salesManId: d['salesManId'] as int,
                    packingOrder: d['packingOrder'] as int,
                    packMultiplyQty: d['packMultiplyQty'] as int,
                  ))
              .toList();

          mobileInvoice = MobileAppSalesInvoiceMaster(
            uuid: (row['uuid']?.toString() ?? ''),
            paidAmount: (row['paidAmount'] as num).toDouble(),
            companyId: row['companyId'] as int ?? 0,
            invoiceId: row['invoiceId'] as int ?? 0,
            clientId: row['clientId'] as int ?? 0,
            clientName: row['clientName']?.toString() ?? '',
            salesManId: row['salesManId'] as int ?? 0,
            salesManName: row['salesManName']?.toString() ?? '',
            payType: row['payType']?.toString() ?? '',
            invoiceNo: row['invoiceNo']?.toString() ?? '',
            invoiceDate: row['invoiceDate']?.toString() ?? '',
            routeId: row['routeId'] as int ?? 0,
            branchId: row['branchId'] as int ?? 0,
            branchName: row['branchName']?.toString() ?? '',
            netTotal: (row['netTotal'] as num).toDouble(),
            totalAmount: (row['totalAmount'] as num).toDouble(),
            totalDiscountVal: (row['totalDiscountVal'] as num).toDouble(),
            totalDiscountPer: 0,
            details: details,
            totalTaxableAmount: (row['totalTaxableAmount'] as num).toDouble(),
            totalSgstAmount: (row['totalSgstAmount'] as num).toDouble(),
            totalIgstAmount: (row['totalIgstAmount'] as num).toDouble(),
            totalCgstAmount: (row['totalCgstAmount'] as num).toDouble(),
            totalCessAmount: (row['totalCessAmount'] as num).toDouble(),
            srtVoucherNo: row['srtVoucherNo']?.toString() ?? '',
            receiptNo: row['receiptNo']?.toString() ?? '',
            longitude: row['longitude']?.toString() ?? '',
            latitude: row['latitude']?.toString() ?? '',
            mobile: row['mobile']?.toString() ?? '',
          );

          invoices.add(mobileInvoice);
        }
      }
    } else {
      final List<Map<String, dynamic>> invoiceRows = await db.query(
          'mobile_app_sales_invoice_master',
          where: 'clientId = ? AND branchId = ? AND companyId = ?',
          whereArgs: [partyId, vehicleId, companyId]);

      for (var row in invoiceRows) {
        final detailRows = await db.query(
          'mobile_app_sales_invoice_master_dt',
          where: 'invoiceId = ?',
          whereArgs: [row['invoiceId']],
        );

        MobileAppSalesInvoiceMaster? mobileInvoice;

        if (detailRows.isNotEmpty) {
          // final s = subInvoiceRows.first;

          final details = detailRows
              .map((d) => MobileAppSalesInvoiceMasterDt(
                    siNo: d['siNo'] as int,
                    productId: d['productId'] as int,
                    companyId: d['companyId'] as int,
                    clientId: d['clientId'] as int,
                    partNumber: d['partNumber']?.toString() ?? '',
                    productName: d['productName']?.toString() ?? '',
                    packingId: d['packingId'] as int,
                    packingName: d['packingName']?.toString() ?? '',
                    quantity: (d['quantity'] as num).toDouble(),
                    foc: (d['foc'] as num).toDouble(),
                    srtQty: (d['srtQty'] as num).toDouble(),
                    totalQty: (d['totalQty'] as num).toDouble(),
                    unitRate: (d['unitRate'] as num).toDouble(),
                    totalRate: (d['totalRate'] as num).toDouble(),
                    mobile: row['mobile']?.toString() ?? '',
                    salesManName: row['salesManName']?.toString() ?? '',
                    routeId: d['routeId'] as int,
                    packQty: d['packQty'] as int,
                    netRate: (d['netRate'] as num).toDouble(),
                    invoiceNo: row['invoiceNo']?.toString() ?? '',
                    invoiceId: d['invoiceId'] as int,
                    invoiceDate: d['invoiceDate']?.toString() ?? '',
                    clientName: d['clientName']?.toString() ?? '',
                    branchName: d['branchName']?.toString() ?? '',
                    branchId: d['branchId'] as int,
                    salesManId: d['salesManId'] as int,
                    packingOrder: d['packingOrder'] as int,
                    packMultiplyQty: d['packMultiplyQty'] as int,
                  ))
              .toList();

          mobileInvoice = MobileAppSalesInvoiceMaster(
            paidAmount: (row['paidAmount'] as num).toDouble(),
            companyId: row['companyId'] as int,
            invoiceId: row['invoiceId'] as int,
            clientId: row['clientId'] as int,
            clientName: row['clientName']?.toString() ?? '',
            salesManId: row['driverId'] as int,
            salesManName: row['driverName']?.toString() ?? '',
            payType: row['payType']?.toString() ?? '',
            invoiceNo: row['invoiceNo']?.toString() ?? '',
            invoiceDate: row['invoiceDate']?.toString() ?? '',
            routeId: row['routeId'] as int,
            branchId: row['vehicleId'] as int,
            branchName: row['vehicleNo']?.toString() ?? '',
            netTotal: (row['netTotal'] as num).toDouble(),
            totalAmount: (row['total'] as num).toDouble(),
            totalDiscountVal: (row['discountAmount'] as num).toDouble(),
            totalDiscountPer: (row['totalDiscountPer'] as num).toDouble(),
            details: details,
            totalTaxableAmount: (row['totalTaxableAmount'] as num).toDouble(),
            totalSgstAmount: (row['totalSgstAmount'] as num).toDouble(),
            totalIgstAmount: (row['totalIgstAmount'] as num).toDouble(),
            totalCgstAmount: (row['totalCgstAmount'] as num).toDouble(),
            totalCessAmount: (row['totalCessAmount'] as num).toDouble(),
            srtVoucherNo: row['srtVoucherNo']?.toString() ?? '',
            receiptNo: row['receiptNo']?.toString() ?? '',
            longitude: row['longitude']?.toString() ?? '',
            latitude: row['latitude']?.toString() ?? '',
            mobile: row['mobile']?.toString() ?? '',
            uuid: row['uuid']?.toString() ?? ''
          );

          invoices.add(mobileInvoice);
        }
      }
    }

    var pendingOrder = await getPendingOrders();
    for (var row in pendingOrder) {
      var invoice = MobileAppSalesInvoiceMaster(
        uuid: row.uuid,
          paidAmount: row.paidAmount.toDouble(),
          companyId: row.companyId,
          invoiceId: row.invoiceId,
          clientId: row.clientId,
          clientName: row.clientName,
          salesManId: row.driverId,
          salesManName: row.driverName,
          payType: row.payType,
          invoiceNo: row.invoiceNo,
          invoiceDate: row.invoiceDate,
          routeId: row.routeId,
          branchId: row.vehicleId,
          branchName: row.vehicleNo,
          netTotal: row.netTotal,
          totalAmount: row.total,
          totalDiscountVal: row.discountAmount,
          totalDiscountPer: row.discountPercentage,
          details: [],
          totalTaxableAmount: row.total,
          totalSgstAmount: 0,
          totalIgstAmount: 0,
          totalCgstAmount: 0,
          totalCessAmount: 0,
          srtVoucherNo: '',
          receiptNo: '',
          longitude: row.longitude.toString(),
          latitude: row.latitude.toString(),
          mobile: '');
      invoices.add(invoice);
    }
    return invoices;
  }

  // ------------------------------- + ----
  // In Active , Active Clients
  // ------------------------------- + ----

  Future<void> insertActiveClients(List<ClientActiveInActiveModel> clients) async {
    final db = await database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final client in clients) {
        final data = client.toJson();
        data['clientType'] = 'ACTIVE';
        batch.insert(
          'clients_active_inactive',
          data,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true); // set noResult to true for speed
    });
  }

  Future<void> insertInActiveClients(List<ClientActiveInActiveModel> clients) async {
    final db = await database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final client in clients) {
        final data = client.toJson();
        data['clientType'] = 'INACTIVE';
        batch.insert(
          'clients_active_inactive',
          data,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true); // set noResult to true for speed
    });
  }

  Future<List<ClientActiveInActiveModel>> getActiveClients(int? routeId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('clients_active_inactive',
        where: 'routeId = ? AND clientType = ?',
        whereArgs: [routeId, 'ACTIVE']);

    return List.generate(maps.length, (i) {
      return ClientActiveInActiveModel.fromJson(maps[i]);
    });
  }

  Future<List<ClientActiveInActiveModel>> getInActiveClients(int? routeId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('clients_active_inactive',
        where: 'routeId = ? AND clientType = ?',
        whereArgs: [routeId, 'INACTIVE']);

    return List.generate(maps.length, (i) {
      return ClientActiveInActiveModel.fromJson(maps[i]);
    });
  }

  Future<bool> isEmptyActiveClients(int? routeId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM clients_active_inactive WHERE routeId = ? AND clientType = ?',
      [routeId, 'ACTIVE'],
    );
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count == 0;
  }

  Future<int> countActiveClients(int? routeId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM clients_active_inactive WHERE routeId = ? AND clientType = ?',
      [routeId, 'ACTIVE'],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> countInActiveClients(int? routeId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM clients_active_inactive WHERE routeId = ? AND clientType = ?',
      [routeId, 'INACTIVE'],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<bool> isEmptyInActiveClients(int? routeId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM clients_active_inactive WHERE routeId = ? AND clientType = ?',
      [routeId, 'INACTIVE'],
    );
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count == 0;
  }

  Future<void> clearAllActiveInActiveClient() async {
    final db = await database;
    await db.delete('clients_active_inactive');
  }

  Future<void> clearActiveClient() async {
    final db = await database;
    await db.delete(
      'clients_active_inactive',
      where: "clientType = 'ACTIVE'",
    );
  }

  Future<void> clearInActiveClient() async {
    final db = await database;
    await db.delete(
      'clients_active_inactive',
      where: "clientType = 'INACTIVE'",
    );
  }

  // -------------------------------
  // Clients
  // -------------------------------

  Future<void> insertClients(List<ClientModel> clients) async {
    final db = await database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final client in clients) {
        batch.insert(
          'clients',
          client.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true); // set noResult to true for speed
    });
  }

  Future<void> updateClients(List<ClientModel>? clients, int clientId) async {
    final db = await database;

    await db.transaction((txn) async {
      final batch = txn.batch();

      if (clientId != null) {
        batch.delete(
          'clients',
          where: 'id = ?',
          whereArgs: [clientId],
        );
      }

      for (final client in clients ?? []) {
        batch.insert(
          'clients',
          client.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
    });
  }

  Future<List<ClientModel>> getClients(int? routeId, int? companyId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('clients',
        where: 'routeId = ? AND companyId = ? AND isActive = ?',
        whereArgs: [routeId, companyId,'Y']);

    return List.generate(maps.length, (i) {
      return ClientModel.fromJson(maps[i]);
    });
  }

  Future<void> clearClients() async {
    final db = await database;
    await db.delete('clients');
  }

  Future<bool> isEmptyClients(int? routeId, int? companyId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM clients WHERE  routeId = ? and companyId = ?',
      [routeId, companyId],
    );
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count == 0;
  }

  // -------------------------------
  // Transactions
  // -------------------------------
  Future<void> insertTransactions(List<SalesTransactions>? transactions) async {
    final db = await database;
    await db.transaction((txn) async {
      for (final transaction in transactions!) {
        await txn.insert(
          'sales_transactions',
          transaction.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<List<SalesTransactions>> getTransactions() async {
    final db = await database;
    final maps = await db.query('sales_transactions');
    return maps.map((e) => SalesTransactions.fromJson(e)).toList();
  }

  Future<void> clearTransactions() async {
    final db = await database;
    await db.delete('sales_transactions');
  }

  Future<bool> isEmptySalesTransactions() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT COUNT(*) as count FROM product_stocks');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count == 0;
  }

  // -------------------------------
  // Product Stocks
  // -------------------------------
  Future<void> insertProductStocks(List<ProductStock>? stocks) async {
    final db = await database;
    await db.delete('product_stocks');
    for (final stock in stocks!) {
      await db.insert('product_stocks', stock.toJson());
    }
  }

  Future<List<ProductStock>> getProductStocks() async {
    final db = await database;
    final maps = await db.query('product_stocks');
    return maps.map((e) => ProductStock.fromJson(e)).toList();
  }

  Future<void> clearProductStocks() async {
    final db = await database;
    await db.delete('product_stocks');
  }

  // -------------------------------
  // Sales Summary
  // -------------------------------
  Future<void> insertSalesSummary(List<SalesSummery>? sales) async {
    final db = await database;
    await db.delete('sales_summary');
    for (final item in sales!) {
      await db.insert('sales_summary', item.toJson());
    }
  }

  Future<List<SalesSummery>> getSalesSummary() async {
    final db = await database;
    final maps = await db.query('sales_summary');
    return maps.map((e) => SalesSummery.fromJson(e)).toList();
  }

  Future<void> clearSalesSummary() async {
    final db = await database;
    await db.delete('sales_summary');
  }

  // -------------------------------
  // Credit Summary
  // -------------------------------
  Future<void> insertCreditSummary(List<CreditSummery>? credit) async {
    final db = await database;
    await db.delete('credit_summary');
    for (final item in credit!) {
      await db.insert('credit_summary', item.toJson());
    }
  }

  Future<List<CreditSummery>> getCreditSummary() async {
    final db = await database;
    final maps = await db.query('credit_summary');
    return maps.map((e) => CreditSummery.fromJson(e)).toList();
  }

  Future<void> clearCreditSummary() async {
    final db = await database;
    await db.delete('credit_summary');
  }

  // -------------------------------
  // Cash Summary
  // -------------------------------
  Future<void> insertCashSummary(List<CashSummery>? cash) async {
    final db = await database;
    await db.delete('cash_summary');
    for (final item in cash!) {
      await db.insert('cash_summary', item.toJson());
    }
  }

  Future<List<CashSummery>> getCashSummary() async {
    final db = await database;
    final maps = await db.query('cash_summary');
    return maps.map((e) => CashSummery.fromJson(e)).toList();
  }

  Future<void> clearCashSummary() async {
    final db = await database;
    await db.delete('cash_summary');
  }

  // -------------------------------
  // Cash Credit Details
  // -------------------------------
  Future<void> insertCashCreditDetails(
      List<CashCreditDetailsModel>? details) async {
    final db = await database;
    await db.delete('cash_credit_details');
    for (final item in details!) {
      await db.insert('cash_credit_details', item.toJson());
    }
  }

  Future<List<CashCreditDetailsModel>> getCashCreditDetails() async {
    final db = await database;
    final maps = await db.query('cash_credit_details',
    where: '(debit IS NOT NULL AND credit IS NOT NULL AND debit <> credit)');
    return maps.map((e) => CashCreditDetailsModel.fromJson(e)).toList();
  }

  Future<void> clearCashCreditDetails() async {
    final db = await database;
    await db.delete('cash_credit_details');
  }

  Future<void> updateClientSyncDateStamp(DateTime dateTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('clientSyncDate', dateTime.toString());
    print("✅ Saved: route=$dateTime");
  }

  Future<String?> getClientSyncDateStamp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('clientSyncDate');
  }
}
