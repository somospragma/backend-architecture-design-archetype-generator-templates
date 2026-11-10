package ${configClassPackage};

import io.r2dbc.spi.ConnectionFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.r2dbc.connection.init.ConnectionFactoryInitializer;

/**
 * R2DBC configuration for PostgreSQL.
 * Spring Boot auto-configures the ConnectionFactory (spring.r2dbc.*) and the
 * repositories under the application package; this class only adds the
 * optional schema initializer.
 */
@Configuration
public class ${adapterName}R2dbcConfig {

    @Bean
    public ConnectionFactoryInitializer ${adapterName?uncap_first}Initializer(ConnectionFactory connectionFactory) {
        ConnectionFactoryInitializer initializer = new ConnectionFactoryInitializer();
        initializer.setConnectionFactory(connectionFactory);

        // Uncomment to run schema.sql on startup
        // var populator = new org.springframework.r2dbc.connection.init.ResourceDatabasePopulator();
        // populator.addScript(new org.springframework.core.io.ClassPathResource("schema.sql"));
        // initializer.setDatabasePopulator(populator);

        return initializer;
    }
}
