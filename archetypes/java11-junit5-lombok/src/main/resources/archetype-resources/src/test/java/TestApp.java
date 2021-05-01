package ${package};

import static org.junit.jupiter.api.Assertions.assertEquals;

import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;

@Slf4j
public class TestApp {

  @Test
  public void testApp() {
    log.info("Running test");
    boolean ret = true;

    assertEquals(ret, true);
  }
}
