library faker.example;

import 'package:faker/faker.dart';

void fakerTest() {
  // Generate some different types of data.
  //faker.randomGenerator.setSeed(3);
  for(int i=0 ; i<4; i++){

    faker.randomGenerator.setSeed(1);

    print(faker.address.country());
    print(faker.company.name());
    print(faker.currency.code());
    print(faker.internet.ipv4Address());
    print(faker.job.title());
    print(faker.person.firstName());
    print(faker.sport.name());

    // Generate a random amount of IP v4 addresses (max 10).
    print(random.amount((_) => faker.internet.ipv4Address(), 10));

    // Generate random boolean.
    print(random.boolean());

    // Generate random decimal.
    print(random.decimal());

    // Generate random DateTime, between the years 2000 and 2020
    print(faker.date.dateTime(minYear: 2000, maxYear: 2020));

    // Generate random User Agent, with osName iOS
    //print(faker.internet.userAgent(osName: 'iOS'));
  }
}