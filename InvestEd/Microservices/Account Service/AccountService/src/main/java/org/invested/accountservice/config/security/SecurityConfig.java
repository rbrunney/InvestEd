package org.invested.accountservice.config.security;

import org.invested.accountservice.config.filter.CustomAuthorizationFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableMBeanExport;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    // To Keep track of current active users
    private final InMemoryUserDetailsManager memAuth = new InMemoryUserDetailsManager();

    @Bean
    public AuthenticationManager authenticationManager(HttpSecurity http, UserDetailsService userDetailsService) throws Exception {
        return http.getSharedObject(AuthenticationManagerBuilder.class)
                .userDetailsService(userDetailsService) // Pass in the userDetails service we are going to be keeping track off
                .passwordEncoder(passwordEncoder()) // Defaulting password encryption to BCrypt
                .and()
                .build();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception{
        return authenticationConfiguration.getAuthenticationManager(); // Getting Authentication manager context
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http.csrf().disable()
                .httpBasic(Customizer.withDefaults())
                .authorizeRequests()
                .antMatchers(HttpMethod.POST, "/invested_account").permitAll()
                .antMatchers(HttpMethod.POST, "/invested_account/check_taken/**").permitAll()
                .antMatchers(HttpMethod.POST, "/invested_account/authenticate").permitAll()
                .antMatchers(HttpMethod.GET, "/invested_account/forgot_password").permitAll()
                .antMatchers(HttpMethod.PUT, "/invested_account/buying_power/**").hasRole("ADMIN")
                .antMatchers(HttpMethod.GET, "/invested_account/test").hasAnyAuthority("ROLE_USER")
                .antMatchers(HttpMethod.GET, "/invested_account/buying_power").hasAnyAuthority("ROLE_USER")
                .antMatchers(HttpMethod.DELETE, "/invested_account").hasAnyAuthority("ROLE_USER")
                .antMatchers(HttpMethod.PUT, "/invested_account").hasAnyAuthority("ROLE_USER")
                .antMatchers(HttpMethod.GET, "/invested_account/encrypt/**").permitAll()
                .and()
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
                .addFilterBefore(new CustomAuthorizationFilter(), UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(); // Using Bcrypt for any user for there passwords
    }

    @Bean
    public UserDetailsService userDetailsService() {
        UserDetails newUser = User.withUsername(System.getenv("CUSTOM_USERNAME"))
                .password(passwordEncoder().encode(System.getenv("CUSTOM_PASSWORD")))
                .roles("ADMIN").build();

        memAuth.createUser(newUser);
        return memAuth;
    }
}
