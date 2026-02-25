package ${packageName}.infrastructure.driven-adapters.mongodb.config;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.config.AbstractMongoClientConfiguration;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

/**
 * MongoDB configuration for ${adapterName}.
 * Configures MongoDB client and template.
 */
@Configuration
@EnableMongoRepositories(basePackages = "${packageName}.infrastructure.driven-adapters.mongodb")
public class ${adapterName}MongoConfig extends AbstractMongoClientConfiguration {

  @Value("${'${spring.data.mongodb.uri}")
  private String mongoUri;

  @Value("${'${spring.data.mongodb.database}")
  private String databaseName;

  @Override
  protected String getDatabaseName() {
    return databaseName;
  }

  @Override
  public MongoClient mongoClient() {
    return MongoClients.create(mongoUri);
  }

  @Bean
  public MongoTemplate mongoTemplate() {
    return new MongoTemplate(mongoClient(), getDatabaseName());
  }
}
